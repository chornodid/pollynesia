require 'spec_helper'

describe Option do
  context 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:poll) }
  end
end
