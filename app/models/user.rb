require 'pollynesia/patterns'

class User < ActiveRecord::Base
  has_many :polls, dependent: :restrict_with_error
  has_many :votes, dependent: :restrict_with_error

  validates_presence_of :email, :firstname, :lastname
  validates_uniqueness_of :email
  validates :email, format: {
    with: Pollynesia::Patterns::EMAIL,
    on: :create
  }

  has_secure_password

  def full_name
    "#{firstname} #{lastname}"
  end
end
