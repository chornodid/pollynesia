require 'spec_helper'
require 'change_poll_status_service'

describe Service::ChangePollStatus do
  let(:poll) { create(:poll, status: old_status) }
  let(:error) { nil }
  let(:block_mock) { double('block') }

  subject { Service::ChangePollStatus.new(poll) }

  before(:each) do
    subject.on_success { block_mock.success }
    subject.on_failure { |message| puts(message); block_mock.error(message) }
  end

  shared_examples 'it_fails' do
    it 'fails' do
      expect(block_mock).to receive(:error).with(/#{expected_message}/)
      expect(subject.call(event)).to be false
    end
  end

  shared_examples 'it_succeeds' do
    it 'succeeds' do
      expect(block_mock).to receive(:success)
      expect(subject.call(event)).to be true
    end
  end

  context 'when event is open' do
    let(:event) { :open }

    context 'when old status is open' do
      let(:old_status) { :open }
      let(:expected_message) { 'already open'}
      include_examples 'it_fails'
    end

    context 'when old status is closed' do
      let(:old_status) { :closed }
      let(:expected_message) { "can't be opened" }
      include_examples 'it_fails'
    end

    context 'when old status is draft' do
      let(:old_status) { :draft }

      before(:each) do
        options_count.times do
          poll.options.create(title: Faker::Lorem.word)
        end
      end

      context 'when has no option' do
        let(:options_count) { 0 }
        let(:expected_message) { 'not ready' }
        include_examples 'it_fails'
      end

      context 'when has one option' do
        let(:options_count) { 1 }
        let(:expected_message) { 'not ready' }
        include_examples 'it_fails'
      end

      context 'when has many options' do
        let(:options_count) { Random.rand(2..5) }
        include_examples 'it_succeeds'
      end
    end
  end

  context 'when event is close' do
    let(:event) { :close }

    context 'when old status is open' do
      let(:old_status) { :open }
      include_examples 'it_succeeds'
    end

    context 'when old status is draft' do
      let(:old_status) { :draft }
      include_examples 'it_succeeds'
    end

    context 'when old status is closed' do
      let(:old_status) { :closed }
      let(:expected_message) { 'already closed'}
      include_examples 'it_fails'
    end

  end
end
