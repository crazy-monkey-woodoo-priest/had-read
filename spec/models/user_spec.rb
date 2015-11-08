require 'rails_helper'

RSpec.describe User, type: :model do
  User.skip_github_prepareness = true

  it { expect(subject).to validate_presence_of(:username) }
  it { expect(subject).to validate_uniqueness_of(:username) }

  describe 'validate presence of reading-log repo', integration: true, vcr: { cassette_name: "github-repo-list" } do
    subject  {  User.new username: 'equivalent' }
    it do
      User.skip_github_prepareness = false
      expect(subject.valid?).to be true
      User.skip_github_prepareness = true
    end
  end
end
