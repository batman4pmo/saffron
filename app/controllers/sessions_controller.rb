class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]

    if user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]).nil?
      if auth["user_info"]["nickname"].blank?
        session[:auth] = auth.except("extra")
        redirect_to register_url
      else
        User.create_with_omniauth(auth)
        session[:user_id] = user.id
        callback
      end
    else
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"])
      session[:user_id] = user.id
      callback
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
  def callback
    redirect_to request.env['omniauth.origin'] || '/default'
  end

end
