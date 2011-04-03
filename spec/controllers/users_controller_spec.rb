require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do

    before (:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("div>img", :class => "gravatar")
    end
  end

  describe "GET 'new'" do

    describe "when accessing directly" do
      it "should be successful" do
        get :new
        response.code.should == "302"
        response.should redirect_to "/auth/open_id"
      end
    end

    describe "when accessing via /auth/open_id" do

      pending "it should populate the user's email address"
      pending "it should populate the user's display name"
    end

  end

  describe "POST 'create'" do

    describe "failure" do

      before (:each) do
        @attr = {:name => "", :email => ""}
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Register")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

    end
  end
end
