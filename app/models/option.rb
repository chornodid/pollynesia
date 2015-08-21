class Option < ActiveRecord::Base
  acts_as_list scope: :poll

  belongs_to :poll
  has_many :votes, dependent: :restrict_with_error

  validates_presence_of :title
end
