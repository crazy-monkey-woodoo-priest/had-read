class Commit < ActiveRecord::Base
  # as the project is always forked, there will be this sha present
  FIRST_SHA = 'cdd7aacc9cdd1021083dc39dc2810fc3bc9cacac'

  scope :with_author, ->(username){ where(author: username) }
  scope :unprocessed, ->{ where(processed_at: nil) }
  scope :processed,   ->{ where.not(processed_at: nil) }
  scope :latest,      ->{ order("commits.id DESC") }
  scope :viewable,    ->{ select { |commits| commits.links.any?} }

  belongs_to :user,
    class_name: 'User',
    primary_key: "username",
    foreign_key: "author"

  # todo move too user model
  def self.latest_commit(username)
    with_author(username).latest.first
  end

  def self.latest_processed_sha(username)
    with_author(username).processed.pluck(:sha).first || FIRST_SHA
  end

  def self.unprocessed_shas(username)
    with_author(username).unprocessed.pluck(:sha)
  end

  def set_processed
    self.processed_at = Time.now
  end

  def avatar_small
    "#{avatar}&s=60"
  end

  def author_url
    "https://github.com/#{author}/"
  end

  def link_objects
    @link_objects ||= LinkObjects.new(links)
  end
end
