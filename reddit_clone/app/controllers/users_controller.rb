class UsersController < ApplicationController

    before_action :ensure_logged_in, only: []

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            sign_in(@user)
            redirect_to users_url
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    def index
        @users = User.all
    end

    private
    def user_params 
        params.require(:user).permit(:name, :password)
    end
end