require 'rails_helper'

RSpec.describe ReadingLogProcessor do
  subject(:processor) { described_class.new(username: username) }
  let(:username) { 'equivalent' }

  describe '#pull_commits', vcr: { cassette_name: "github-commits" } do
    context 'given no previous commits' do
      let(:trigger) { processor.pull_commits }

      it 'should create all commits' do
        expect { trigger }
          .to change { Commit.with_author(username).count }
          .from(0).to(71)

        commit = Commit.first

        expect(commit.sha).to eq 'd7812cad66d725b43c0a362f2fd318487bbb1cae'
        expect(commit.message).to eq 'Update reading-log.md'
        expect(commit.commited_at).to eq Time.parse('Wed, 04 Nov 2015 08:12:44 UTC +00:00')
        expect(commit.author).to eq username
        expect(commit.processed_at).to be nil

        commit = Commit.last
        expect(commit.sha).to eq 'cdd7aacc9cdd1021083dc39dc2810fc3bc9cacac'
      end
    end

    context 'given previous commits' do
      let(:trigger) { processor.pull_commits } # position 5

      before do
        create :commit, author: username, sha: '9c67600af1b176e61d37c94bb871344b79244882'
      end

      it 'should create all commits' do
        expect { trigger }
          .to change { Commit.with_author(username).count }
          .by(4)

        commits = Commit.all[1..4]
        expect(commits.first.sha).to eq 'd7812cad66d725b43c0a362f2fd318487bbb1cae'
        expect(commits.last.sha).to eq 'fda59c6971950cc39f1f7526eef4b04f5c27a22c'
      end
    end
  end

  describe '#process_commits', vcr: { cassette_name: "github-compare" } do
    let(:username) { 'had-read-tester' }

    before do
      %w(
        c8df4d5a39224e14496996588112b7f834b7ea7f
        abd53248e6b5875436651b92f4edc0631a54f374
        1e996dc5607c3a52e8c420a3ea1b8e6ff7187846
        9c1648f0ed4b0d697e89a39a8fa79a807a0f5136
      ).each do |sha|
        create :commit, sha: sha, author: username
      end

      processor.process_commits
    end

    let(:commits) { Commit.with_author(username) }

    it do
      expect(commits[0].links).to match_array([])
    end

    it do
      expect(commits[0].processed_at).to be_within(1.minute).of(Time.now)
    end

    it do
      expect(commits[1].links).to match_array([
        {"url"=>"https://google.com", "message"=>"google hah hah"}
      ])
    end

    it do
      expect(commits[2].links).to match_array([
        {"url"=>"http://had-read.r15.railsrumble.com/", "message"=>"cool appp for bookmarks"},
        {"url"=>"https://github.com/had-read/had-read", "message"=>nil}
      ])
    end

    it do
      expect(commits[3].links).to match_array([
        {"url"=>"http://www.eq8.eu", "message"=>"EquiValent website"},
        {"url"=>"http://daringfireball.net/projects/markdown/syntax#list", "message"=>nil},
        {"url"=>"https://help.github.com/articles/github-flavored-markdown/", "message"=>nil}
      ])
    end
  end
end
