require 'take_vote_service'

class VotesController < ApplicationController
  before_filter :authorize

  def index
    @votes = Vote.where(user: current_user).include(:options)
  end

  def create
    option = Option.find(params[:option_id])
    service = Service::TakeVote.new(
      user: current_user, option: option, ip_address: request.remote_ip
    )
    service.on_success do
      redirect_to poll_path(option.poll),
                  notice: 'Thank you! Your vote has been taken'\
                          " with option #{option.title}"
    end
    service.on_failure do |error|
      redirect_to poll_path(option.poll), alert: error
    end
    service.call
  end
end
