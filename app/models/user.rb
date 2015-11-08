class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true

  has_many :commits,
    :primary_key => "username",
    :foreign_key => "author"

  def to_param
    username
  end
end
