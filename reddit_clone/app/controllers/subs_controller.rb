class SubsController < ApplicationController

    before_action :ensure_signed_in, only: [:create, :destroy, :edit, :update]
    before_action :ensure_moderator , only: [:edit, :update, :destroy]

    def ensure_moderator
        @sub = Sub.find(params[:id])
        redirect_to subs_url unless current_user.id == @sub.moderator_id
    end

    def new
        @sub = Sub.new
    end

    def create
        @sub = Sub.new(sub_params)
        @sub.moderator_id = params(:user_id)
        if @sub.save
            redirect_to subs_url
        else
            flash.now[:errors] = @sub.errors.full_messages
            render :new
        end
    end

    def destroy
        @sub = Sub.find(params[:id])
        @sub.destroy
        redirect_to subs_url
    end

    def edit
        @sub = Sub.find(params[:id])
    end

    def update
        @sub = Sub.find(params[:id])
        if @sub.update(sub_params)
            redirect_to sub_url(@sub)
        else
            flash.now[:errors] = @sub.errors.full_messages
            render :edit 
        end
    end

    def index
        @subs = Sub.all
        render :index
    end

    def show
        @sub = Sub.find(params[:id])
    end

    private
    def sub_params
        params.require(:sub).permit(:title, :description)
    end
end
