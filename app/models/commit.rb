class Commit < ActiveRecord::Base
  scope :with_author, ->(username){ where(author: username) }
  scope :unprocessed, ->{ where(processed_at: nil) }

  def self.latest_commit(username)
    with_author(username).last
  end

  def set_processed
    self.processed_at = Time.now
  end
end
