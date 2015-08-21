require 'spec_helper'
require 'permit_user_to_change_poll_status_service'

# TODO: Refactor, ratio of test-to-code lines is to high - 4:1
describe Service::PermitUserToChangePollStatus do
  subject do
    Service::PermitUserToChangePollStatus.new(
      user: user, poll: poll, event: event
    )
  end

  let(:poll) { create(:poll, status: old_status, user: author) }
  let(:user) { create(:user, is_admin: is_admin) }
  let(:is_admin) { false }

  shared_examples 'it_succeeds' do
    it 'succeeds' do
      expect(subject.allowed?).to be true
    end
  end

  shared_examples 'it_fails' do |error|
    it 'fails' do
      expect(subject.allowed?).to be false
      expect(subject.error).to match(/#{error}/i)
    end
  end

  context 'when status is draft' do
    let(:old_status) { :draft }

    context 'when event is open' do
      let(:event) { :open }

      context 'when user' do
        context 'is author' do
          let(:author) { user }

          include_examples 'it_succeeds'
        end

        context 'is not author' do
          let(:author) { create(:user) }

          include_examples 'it_fails', 'author is allowed'
        end
      end
    end

    context 'when event is close' do
      let(:event) { :close }

      context 'when user' do
        context 'is admin' do
          let(:is_admin) { true }
          let(:author) { create(:user) }

          include_examples 'it_succeeds'
        end

        context 'is author' do
          let(:author) { user }

          include_examples 'it_succeeds'
        end

        context 'is not author and admin' do
          let(:is_admin) { false }
          let(:author) { create(:user) }

          include_examples 'it_fails', 'author or admin is allowed'
        end
      end
    end
  end

  context 'when status is open' do
    let(:old_status) { :open }

    context 'when event is open' do
      let(:event) { :open }
      let(:author) { user }
      let(:is_admin) { true }

      include_examples 'it_fails', 'already open'
    end

    context 'when event is close' do
      let(:event) { :close }

      context 'when user' do
        context 'is admin' do
          let(:is_admin) { true }
          let(:author) { create(:user) }

          include_examples 'it_succeeds'
        end

        context 'is author' do
          let(:author) { user }

          include_examples 'it_succeeds'
        end

        context 'is not author and admin' do
          let(:is_admin) { false }
          let(:author) { create(:user) }

          include_examples 'it_fails', 'author or admin is allowed'
        end
      end
    end
  end

  context 'when status is closed' do
    let(:old_status) { :closed }

    context 'when event is close' do
      let(:event) { :close }
      let(:author) { user }
      let(:is_admin) { true }

      include_examples 'it_fails', 'already closed'
    end
  end

  context 'when unknown event' do
    let(:old_status) { :open }
    let(:event) { :unknown }
    let(:author) { user }
    let(:is_admin) { true }

    it 'raise error' do
      expect { subject.allowed? }.to raise_error(ArgumentError,
                                                 /unknown event/i)
    end
  end
end
