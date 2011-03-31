class PagesController < ApplicationController

  def home
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
