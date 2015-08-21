class Vote < ActiveRecord::Base
  belongs_to :option
  belongs_to :user

  validates_format_of :ip_address, with: Pollynesia::Patterns::IP_ADDRESS,
                                   on: create, allow_nil: true
end
