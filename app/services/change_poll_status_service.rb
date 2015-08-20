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
      error = check_open
      if error
        @on_failure.call(error) if @on_failure
        return false
      end

      @poll.update!(status: :open)
      @on_success.call
      true
    end

    def check_open
      return 'Poll is already open' if @poll.is_open?
      return "Closed poll can't be opened" if @poll.is_closed?
      return "Poll is not ready" if !@poll.is_ready?
    end

    def close
      error = check_close
      if error
        @on_failure.call(error) if @on_failure
        return false
      end

      @poll.update!(status: :closed)
      @on_success.call
      true
    end

    def check_close
      'Poll is already closed' if @poll.is_closed?
    end
  end
end
