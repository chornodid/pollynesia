require 'spec_helper'

describe Option do
  context 'validation' do
    it { should validate_presence_of(:title) }
  end
end
