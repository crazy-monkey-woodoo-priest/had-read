require 'rails_helper'

RSpec.describe ReadingLogProcessor do
  subject(:processor) { described_class.new(username: username) }
  let(:username) { 'equivalent' }

  describe '#pull_commits', vcr: { cassette_name: "github-commits" } do
    context 'given no previous commits' do
      let(:trigger) { processor.pull_commits(nil) }

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
      let(:trigger) { processor.pull_commits('acf2c4ecb9e1569aec0a78e3b1075443aadafd18') } # position 32

      it 'should create all commits' do
        expect { trigger }
          .to change { Commit.with_author(username).count }
          .from(0).to(39)

        commit = Commit.first
        expect(commit.sha).to eq 'd7812cad66d725b43c0a362f2fd318487bbb1cae'

        commit = Commit.last
        expect(commit.sha).to eq 'c9285d9c032a4cdb5e0edd573de38c1887f1f67c'
      end
    end
  end
end
