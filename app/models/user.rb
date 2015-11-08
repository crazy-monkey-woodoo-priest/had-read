class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true

  def to_param
    username
  end
end
