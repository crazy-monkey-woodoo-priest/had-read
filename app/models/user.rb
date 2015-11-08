class User < ActiveRecord::Base
  class ReadingLogExistanceValidator < ActiveModel::Validator
    def validate(record)
      if record.username.present? && !User.skip_github_prepareness
        msg = "repository \"reading-log\" not-found in users Github"
        begin
          user_prepared =ReadingLogProcessor
            .new(username: record.username)
            .user_prepared?
        rescue NoMethodError
          # @todo fix when user not exist
        end

        if !user_prepared
          record.errors[:base] << msg
        end
      end
    end
  end

  class << self
    attr_accessor :skip_github_prepareness
  end

  validates :username, presence: true, uniqueness: true

  has_many :commits,
    :primary_key => "username",
    :foreign_key => "author"

  validates_with ReadingLogExistanceValidator

  def to_param
    username
  end
end
