require 'spec_helper'
require 'change_poll_status_service'

describe Service::ChangePollStatus do
  let(:poll) { create(:poll, status: old_status) }
  let(:block_mock) { double('block') }

  subject { Service::ChangePollStatus.new(poll) }

  shared_examples 'it_fails' do
    before { subject.on_failure { |message| block_mock.error(message) } }
    before { subject.on_success { block_mock.success } }

    it 'fails' do
      expect(block_mock).to receive(:error).with(/#{expected_message}/i)
      expect(block_mock).not_to receive(:success)
      expect(subject.call(event)).to be false
    end
  end

  shared_examples 'it_succeeds' do
    before { subject.on_success { block_mock.success } }

    it 'succeeds' do
      expect(block_mock).to receive(:success)
      expect(block_mock).not_to receive(:error)
      expect(subject.call(event)).to be true
    end
  end

  context 'when event is open' do
    let(:event) { :open }

    context 'when old status is open' do
      let(:old_status) { :open }
      let(:expected_message) { 'already open' }
      include_examples 'it_fails'
    end

    context 'when old status is closed' do
      let(:old_status) { :closed }
      let(:expected_message) { "can't be opened" }
      include_examples 'it_fails'
    end

    context 'when old status is draft' do
      let(:old_status) { :draft }

      before do
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
      let(:expected_message) { 'already closed' }
      include_examples 'it_fails'
    end
  end

  context 'when on_failure block not provided' do
    let(:old_status) { :draft }

    it 'raises exception' do
      expect { subject.call(:open) }.to raise_error(ArgumentError, /not ready/)
    end
  end
end
