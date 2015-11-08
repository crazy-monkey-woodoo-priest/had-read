class CommitsController < ApplicationController
  include UserConcern

  def index
    if username
      set_user
      @commits = @user.commits.latest.viewable
      @title = "#{@user.username}'s reading log"
    else
      @commits = Commit.processed.latest.viewable
      @title = "Latest Commits"
    end
  end

  private
    def username
      params[:user_username]
    end
end
