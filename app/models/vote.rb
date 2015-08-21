require 'pollynesia/patterns'

class Vote < ActiveRecord::Base
  belongs_to :option, required: true
  belongs_to :user, required: true

  validates_format_of :ip_address, with: Pollynesia::Patterns::IP_ADDRESS,
                                   on: :create, allow_nil: true
end
