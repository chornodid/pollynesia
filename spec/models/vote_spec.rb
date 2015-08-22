require 'spec_helper'

describe Vote do
  context 'validation' do
    it { should validate_presence_of(:option) }
    it { should validate_presence_of(:user) }
    it do
      should allow_value(
        '0.0.0.0', '255.255.255.255', '192.168.0.1', '::1',
        '21DA:D3:0:2F3B:2AA:FF:FE28:9C5A',
        '1200:0000:AB00:1234:0000:2552:7777:1313')
        .for(:ip_address).on(:create)
    end
    it do
      should_not allow_value(
        'Z.0.0.0', '0.0.0.Z', '500.0.0.0', '0.0.0.500',
        '1200::AB00:1234::2552:7777:1313',
        '1200:0000:AB00:1234:O000:2552:7777:1313')
        .for(:ip_address).on(:create)
    end
  end
end
