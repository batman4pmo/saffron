require 'spec_helper'

describe SessionsController do
  render_views
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Log in")
    end
    
  end

  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :email => "", :password => "" }
      end
      
      it "should re-render the 'new' page" do
        post :create, :session => @attr
        response.should render_template('new')
      end
      
      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Log in")
      end
      
      it "should have an error message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    describe "success" do
      
      before(:each) do
        @user  = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end
      
      it "should log the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_logged_in
      end
      
      it "should redirect to the root page" do
        post :create, :session => @attr
        response.should redirect_to(root_path)
      end
      
    end
  end

  describe "DELETE 'destroy'" do
    
    it "should log a user out" do
      test_log_in(Factory(:user))
      delete :destroy
      controller.should_not be_logged_in
      response.should redirect_to(root_path)
    end
    
  end
  
end
