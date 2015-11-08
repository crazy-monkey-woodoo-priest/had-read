class Commit < ActiveRecord::Base
  scope :with_author, ->(username){ where(author: username) }
  scope :unprocessed, ->{ where(processed_at: nil) }
  scope :processed,   ->{ where.not(processed_at: nil) }

  def self.latest_commit(username)
    with_author(username).last
  end

  def self.latest_processed_sha(username)
    with_author(username).processed.pluck(:sha).first || 'HEAD'
  end

  def self.unprocessed_shas(username)
    Commit.with_author(username).unprocessed.pluck(:sha)
  end

  def set_processed
    self.processed_at = Time.now
  end
end
