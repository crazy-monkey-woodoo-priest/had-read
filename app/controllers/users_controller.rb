class UsersController < ApplicationController
  before_action :set_user, only: [:show, :refresh]

  def show
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def create
    @user = User.new(user_params)
    @user.save
    respond_with(@user)
  end

  def refresh
    @user.

  end

  private
    def user_params
      params.require(:user).permit(:username)
    end

    def set_user
      @user = User.find_by(username: params[:username])
    end
end
