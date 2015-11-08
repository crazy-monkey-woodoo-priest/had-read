class CommitsController < ApplicationController
  include UserConcern
  helper_method :username

  def index
    if username
      set_user
      if @user
        @commits = @user.commits.viewable(params[:page])
        @title = "#{@user.username}'s reading log"
      end
    else
      @commits = Commit.viewable(params[:page])
      @title = "Latest Commits"
    end
  end

  private
    def username
      params[:user_username]
    end
end
