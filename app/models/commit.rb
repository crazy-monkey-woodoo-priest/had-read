class Commit < ActiveRecord::Base
  scope :with_author, ->(username){ where(author: username) }

  def self.latest_commit(author)
    with_author(username)
  end
end
