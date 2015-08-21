require 'spec_helper'
require 'take_vote_service'

describe Service::TakeVote do
  subject { Service::TakeVote.new(params) }
  let(:block_mock) { double('block') }

  let(:user) { create(:user) }
  let(:poll) { create(:poll, status: status) }
  let(:option) { create(:option, poll: poll) }
  let(:ip_address) { nil }

  let(:params) { { user: user, option: option, ip_address: ip_address } }

  shared_examples 'it_fails' do
    before { subject.on_failure { |e| block_mock.error(e.class, e.message) } }
    before { subject.on_success { block_mock.success } }

    it 'fails' do
      expect(block_mock).to receive(:error).with(ArgumentError,
                                                 /#{expected_message}/i)
      expect(block_mock).not_to receive(:success)
      expect(subject.call).to be false
    end
  end

  shared_examples 'it_succeeds' do
    before { subject.on_success { block_mock.success } }
    before { subject.on_failure { block_mock.error } }

    it 'succeeds' do
      expect(block_mock).to receive(:success)
      expect(block_mock).not_to receive(:error)
      expect(subject.call).to be true
    end
  end

  context 'when poll is draft' do
    let(:expected_message) { 'not open' }
    let(:status) { :draft }

    include_examples 'it_fails'
  end

  context 'when poll is closed' do
    let(:expected_message) { 'not open' }
    let(:status) { :closed }

    include_examples 'it_fails'
  end

  context 'when poll is open' do
    let(:status) { :open }

    context 'when ip address' do
      context 'not provided' do
        let(:ip_address) { nil }

        include_examples 'it_succeeds'
      end

      context 'provided' do
        let(:ip_address) { Faker::Internet.ip_v4_address }

        before do
          taken_votes.times do
            option.votes.create(user: create(:user), ip_address: ip_address)
          end
        end

        context 'when limit' do
          context 'exceeded' do
            let(:taken_votes) { 2 }
            let(:expected_message) { 'ip address' }
            include_examples 'it_fails'
          end

          context 'not exceeded' do
            let(:taken_votes) { 1 }
            include_examples 'it_succeeds'
          end
        end
      end
    end

    context 'when user limit' do
      let(:ip_address) { nil }

      before do
        taken_votes.times do
          option.votes.create(user: user, ip_address: nil)
        end
      end

      context 'exceeded' do
        let(:taken_votes) { 1 }
        let(:expected_message) { 'user' }
        include_examples 'it_fails'
      end

      context 'not exceeded' do
        let(:taken_votes) { 0 }
        include_examples 'it_succeeds'
      end
    end
  end

  context 'when on_failure block not provided' do
    let(:status) { :closed }
    it 'raises exception' do
      expect { subject.call }.to raise_error(ArgumentError, /not open/)
    end
  end
end
