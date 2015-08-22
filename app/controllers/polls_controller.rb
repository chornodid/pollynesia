require 'change_poll_status_service'
require 'permit_user_to_change_poll_status_service'

class PollsController < ApplicationController
  before_filter :authorize, except: [:current, :show]
  before_filter :find_poll, except: [:current, :index, :new, :create]
  before_filter :authenticate, only: [:update]

  def index
    @polls = Poll.order(created_at: :desc)
    if params[:user_id]
      @user = User.find(params[:user_id]) rescue nil
      @polls = @polls.where(user: @user) if @user
    end
    @polls.includes(:user).includes(:count)
    @title = 'Polls'
    @title << " by #{@user.full_name}" if @user
  end

  def current
    @polls = Poll.is_open.order(open_date: :asc).includes(:user)
    @title = 'Current polls'
    render 'index'
  end

  def new
    @poll = Poll.new(params[:project])
    @poll.user = current_user
  end

  def edit
    @poll.options.order(position: :desc)
  end

  def update
    if @poll.update(permit_params)
      redirect_to poll_path(@poll), notice: 'Poll has been succesfully updated'
    else
      render action: 'edit'
    end
  end

  def create
    @poll = Poll.new(permit_params)
    @poll.user = current_user
    if @poll.save
      redirect_to poll_path(@poll), notice: 'Poll has been succesfully created'
    else
      render action: 'new'
    end
  end

  def show
    @poll.options.order(position: :asc)
    @already_taken = current_user.taken_polls.where(id: @poll.id).exists? \
      if current_user
  end

  def change_status
    return unless change_status_allowed?
    service = Service::ChangePollStatus.new(@poll)
    service.on_success do
      redirect_to poll_path(@poll),
                  notice: 'Poll status has been successfully'\
                          " changed to #{@poll.status}."
    end
    service.on_failure { |error| redirect_to poll_path(@poll), alert: error }
    service.call(params[:event].to_sym)
  end

  private

  def find_poll
    @poll = Poll.find(params[:id])
  end

  def change_status_allowed?
    service = Service::PermitUserToChangePollStatus.new(
      poll: @poll, user: current_user, event: params[:event].to_sym
    )
    return true if service.allowed?
    redirect_to poll_path(@poll), alert: service.error
    false
  end

  def authenticate
    redirect_to(
      poll_path(@poll),
      alert: 'Only author is allowed to update poll'
    ) unless @poll.user == current_user
  end

  def permit_params
    params.require(:poll).permit(
      :title, options_attributes: [:id, :title, :position, :_destroy]
    )
  end
end
