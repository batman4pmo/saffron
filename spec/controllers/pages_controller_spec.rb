require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @github_url = "http://github.com/bmaher"
  end

  describe "GET 'home'" do

    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title", :content => "Saffron | Home")
    end
  end

  describe "GET 'wiki'" do

    it "should redirect to GitHub wiki page" do
      get 'wiki'
      response.code.should == "302"
      response.should redirect_to("#{@github_url}/saffron/wiki")
    end
  end

  describe "GET 'contact'" do

    it "should redirect to my GitHub profile page" do
      get 'contact'
      response.code.should == "302"
      response.should redirect_to("#{@github_url}")
    end
  end

  describe "GET 'issues'" do

    it "should redirect to GitHub issues page" do
      get 'issues'
      response.code.should == "302"
      response.should redirect_to("#{@github_url}/saffron/issues")
    end
  end

end
