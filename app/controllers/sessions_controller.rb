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
        redirect_to root_path
      end
    else
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"])
      session[:user_id] = user.id
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
