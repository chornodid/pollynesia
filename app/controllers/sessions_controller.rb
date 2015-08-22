class SessionsController < ApplicationController
  def create
    user = find_user
    if user
      session[:user_id] = user.id
      flash[:notice] = 'You have successfully logged in.'
    else
      flash[:error] = "Email and password don't match."
    end
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def find_user
    user = User.find_by_email(params[:email])
    user && user.authenticate(params[:password])
  end
end
