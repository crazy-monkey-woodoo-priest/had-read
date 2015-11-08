require 'rails_helper'

RSpec.describe Commit, type: :model do

  describe '.latest_commit' do
    subject { described_class.latest_commit('jhon') }

    before do
      create :commit, sha: 'sha1'
      create :commit, sha: 'sha2'
      create :commit, sha: 'sha3', author: 'oli'
    end

    it 'should return latest commit' do
      expect(subject.sha).to eq 'sha2'
    end
  end

  describe '.unprocessed_shas' do
    subject { described_class.unprocessed_shas('jhon') }

    before do
      create :commit, :processed, sha: 'sha1'
      create :commit, sha: 'sha3', author: 'oli'
      create :commit, sha: 'sha2'
    end

    it 'should contain unprocessed shas' do
      expect(subject).to match_array(['sha2'])
    end
  end

  describe '.latest_processed_sha' do
    subject { described_class.latest_processed_sha('jhon') }

    context 'when there is a processed commit' do
      before do
        create :commit, :processed, sha: 'sha1'
        create :commit, sha: 'sha2'
      end

      it { expect(subject).to eq 'sha1' }
    end

    context 'when there is no processed commit' do
      it { expect(subject).to eq 'HEAD' }
    end
  end
end
