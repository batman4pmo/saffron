class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @users = User.all.paginate(:page => params[:page])
    @title = "All users"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Register"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      log_in @user
      redirect_to @user, :flash => {:success => "Welcome to Saffron!"}
    else
      @title = "Register"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit profile"
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => {:success => "Profile updated."}
    else
      @title = "Edit profile"
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, :flash => {:success => "User deleted."}
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    @user = User.find(params[:id])
    redirect_to(root_path) if !current_user.admin || current_user?(@user)
  end

end
