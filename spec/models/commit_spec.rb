require 'rails_helper'

RSpec.describe Commit, type: :model do

  describe '.latest_commit' do
    subject { described_class.latest_commit('jhon') }

    before do
      create :commit, sha: 'sha1', author: 'jhon'
      create :commit, sha: 'sha2', author: 'jhon'
      create :commit, sha: 'sha3', author: 'oli'
    end

    it 'should return latest commit' do
      expect(subject.sha).to eq 'sha2'
    end
  end
end
