require 'spec_helper'

describe User do
  context 'validation' do
    %i(firstname lastname email).each do |key|
      it { should validate_presence_of(key) }
    end
    it { should validate_uniqueness_of(:email) }
  end
end
