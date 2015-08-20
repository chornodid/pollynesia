class Option < ActiveRecord::Base
  acts_as_list scope: :poll

  belongs_to :poll

  validates_presence_of :title
end
