require 'pollynesia/patterns'

class User < ActiveRecord::Base
  validates_presence_of :email, :firstname, :lastname
  validates_uniqueness_of :email
  validates :email, format: {
    with: Pollynesia::Patterns::EMAIL,
    on: :create
  }

  has_secure_password
end
