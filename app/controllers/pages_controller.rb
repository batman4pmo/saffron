class PagesController < ApplicationController

  def home
    @user = User.new
    @title = "Home"
  end

  def wiki
    redirect_to "http://github.com/bmaher/saffron/wiki"
  end

  def issues
    redirect_to "http://github.com/bmaher/saffron/issues"
  end

  def contact
    redirect_to "http://github.com/bmaher"
  end

end
