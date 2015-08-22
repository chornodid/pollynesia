require 'pollynesia/patterns'
require 'ipaddr'

class Vote < ActiveRecord::Base
  belongs_to :option, required: true, counter_cache: true
  belongs_to :user, required: true

  validate :validate_ip_address, on: :create

  def validate_ip_address
    return true unless ip_address
    begin
      IPAddr.new(ip_address)
    rescue IPAddr::Error
      errors.add(:ip_address, 'not valid')
      return false
    end
    true
  end
end
