require 'spec_helper'

describe ProjectsController do

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      @project = @user.projects.create(:name => "My Project", :client => "My Client")
      test_log_in(@user)
    end

    it "should be successful" do
      get :show, :id => @project.id
      response.should be_success
    end

    it "should find the right project" do
      get :show, :id => @project.id
      assigns(:project).should == @project
    end

    it "should have the right title" do
      get :show, :id => @project.id
      response.should have_selector("title", :content => @project.name)
    end

    it "should have the project's name" do
      get :show, :id => @project.id
      response.should have_selector("h1", :content => @project.name)
    end
  end

end
