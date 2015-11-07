class Commit < ActiveRecord::Base
  scope :with_author, ->(username){ where(author: username) }

  def self.latest_commit(username)
    with_author(username).last
  end
end
