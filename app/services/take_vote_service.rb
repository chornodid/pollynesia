module Service
  class TakeVote
    LIMITS = {
      user: 1,
      ip_address: 2
    }.freeze

    def initialize(user:, option:, ip_address: nil)
      @user = user
      @option = option
      @ip_address = ip_address
    end

    def on_success(&block)
      @on_success = block
      self
    end

    def on_failure(&block)
      @on_failure = block
      self
    end

    def call
      Rails.logger.info('before permit')
      Rails.logger.info("ip = #{@ip_address}")

      begin
        permit_vote
        Rails.logger.info('before create')
        @option.votes.create!(user: @user, ip_address: @ip_address)
      rescue => e
        raise e unless @on_failure
        @on_failure.call(e.message)
        return false
      end

      @on_success.call
      true
    end

    private

    def permit_vote
      fail(ArgumentError, 'Poll is not open') unless @option.poll.open?
      queries.each do |key, query|
        taken = query.count
        next if taken < LIMITS[key]
        fail(ArgumentError, error_message(key, taken))
      end
    end

    def queries
      query = @option.poll.votes
      {
        user: query.where(user: @user),
        ip_address: query.where(ip_address: @ip_address)
      }
    end

    def error_message(key, count)
      votes = "#{count} #{'vote'.pluralize(count)}"
      "Already taken #{votes} from this #{key.to_s.humanize}"
    end
  end
end
