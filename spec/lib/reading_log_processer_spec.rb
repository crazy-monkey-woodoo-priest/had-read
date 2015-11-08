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
    before do
      [
        "867515c9e145b8a35b68ad8dcbd6ba5a4e39b0c9",
        "5680d1db3ab4ec2bf76c8ad6bbec3ec0ef8303c8",
        "fda59c6971950cc39f1f7526eef4b04f5c27a22c"
      ].each do |sha|
        create :commit, sha: sha, author: username
      end
    end

    it do
      subject.process_commits

      a =  Commit.pluck(:links)
      p a

    end
  end
end
