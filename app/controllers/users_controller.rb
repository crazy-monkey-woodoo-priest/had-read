class UsersController < ApplicationController
  include UserConcern

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
    ReadingLogProcessor.new(username: @user.username)
      .tap { |r| r.pull_commits }
      .tap { |r| r.process_commits }
    redirect_to user_path(@user), notice: "Refresh of #{@user.username} log successful"
  end

  private
    def user_params
      params.require(:user).permit(:username)
    end

end
