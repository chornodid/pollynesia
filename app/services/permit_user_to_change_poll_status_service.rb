module Service
  class PermitUserToChangePollStatus
    attr_reader :error

    def initialize(user:, poll:, event:)
      @poll = poll
      @event = event
      @user = user
    end

    def allowed?
      @error = nil
      case @event
      when :open then permit_to_open
      when :close then permit_to_close
      else fail(ArgumentError, "Unknown event #{@event}")
      end
      @error.nil?
    end

    private

    def permit_to_open
      @error = 'Already open' if @poll.open?
      @error = 'Already close' if @poll.closed?
      @error = 'Only author is allowed to open' unless @poll.user == @user
    end

    def permit_to_close
      @error = 'Already closed' if @poll.closed?
      @error = 'Only author or admin is allowed to close' if \
        @poll.user != @user && !@user.admin?
    end
  end
end
