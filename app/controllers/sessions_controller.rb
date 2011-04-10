class SessionsController < ApplicationController

  def create
    @auth = request.env["omniauth.auth"]

    if registered_user?
      log_in_user
    else
      if missing_details?
        session[:auth] = @auth.except("extra")
        redirect_to register_url
      else
        User.create_with_omniauth(@auth)
        log_in_user
      end
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

  def failure
    redirect_to root_url, :notice => 'Sorry, something went wrong whilst trying to log you in! Please try again'
  end

  private
  def registered_user?
    @user = User.find_by_provider_and_uid(@auth["provider"], @auth["uid"])
  end

  def log_in_user
    session[:user_id] = @user.id
    callback
  end

  def missing_details?
    @auth["user_info"]["nickname"].blank? or @auth["user_info"]["email"].blank?
  end

  def callback
    redirect_to request.env['omniauth.origin'] || '/default'
  end

end
