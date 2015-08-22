require 'take_vote_service'

class VotesController < ApplicationController
  before_filter :authorize

  def index
    @votes = Vote.where(user: current_user).include(:options)
  end

  def create
    option = Option.find(params[:option_id])
    poll = option.poll
    service = Service::TakeVote.new(
      user: current_user, option: option, ip_address: request.remote_ip
    )
    service.on_success do
      redirect_to poll_path(poll),
                  notice: 'Thank you! Your vote has been taken'\
                          " with option #{option.title}"
    end
    service.on_failure { |error| redirect_to poll_path(poll), alert: error }
    service.call
  end
end
