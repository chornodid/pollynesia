class UsersController < ApplicationController
  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'You have successfully created user.'
      redirect_to '/'
    else
      render action: 'new'
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end
end
