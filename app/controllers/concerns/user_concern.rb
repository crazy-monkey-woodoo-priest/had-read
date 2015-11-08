module UserConcern

  protected
    def set_user
      @user = User.find_by(username: username)
    end

    def username
      params[:username]
    end
end
