class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    if session[:auth].nil?
      redirect_to "/auth/open_id"
    else
      @user = User.new
      @openid_email = session[:auth]["user_info"]["email"]
      @title = "Register"
    end
  end

  def create
    @user = User.new(params[:user])
    @user.provider = session[:auth]["provider"]
    @user.uid      = session[:auth]["uid"]
    if @user.save
      session[:user_id] = @user
      redirect_to root_path
    else
      render 'new'
    end
  end

end
