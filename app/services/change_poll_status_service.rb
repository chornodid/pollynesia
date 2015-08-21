module Service
  class ChangePollStatus
    def initialize(poll)
      @poll = poll
    end

    def on_success(&block)
      @on_success = block
      self
    end

    def on_failure(&block)
      @on_failure = block
      self
    end

    def call(event)
      case event
      when :close then close
      when :open then open
      else
        @on_failure.call("Unknown event #{new_status}") if @on_failure
        false
      end
    end

    private

    def open
      begin
        permit_open
        @poll.update!(status: :open)
      rescue => e
        raise e unless @on_failure
        @on_failure.call(e)
        return false
      end

      @on_success.call
      true
    end

    def permit_open
      fail(ArgumentError, 'Poll is already open') if @poll.open?
      fail(ArgumentError, "Closed poll can't be opened") if @poll.closed?
      fail(ArgumentError, 'Poll is not ready') unless @poll.ready?
    end

    def close
      begin
        permit_close
        @poll.update!(status: :closed)
      rescue => e
        raise e unless @on_failure
        @on_failure.call(e)
        return false
      end

      @on_success.call
      true
    end

    def permit_close
      fail(ArgumentError, 'Poll is already closed') if @poll.closed?
    end
  end
end
