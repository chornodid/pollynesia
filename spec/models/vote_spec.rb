require 'spec_helper'

describe Vote do
  context 'validation' do
    it { should validate_presence_of(:option) }
    it { should validate_presence_of(:user) }
    it do
      should allow_value('0.0.0.0', '255.255.255.255', '192.168.0.1')
        .for(:ip_address).on(:create)
    end
    it do
      should_not allow_value('Z.0.0.0', '0.0.0.Z', '500.0.0.0', '0.0.0.500')
        .for(:ip_address).on(:create)
    end
  end
end
