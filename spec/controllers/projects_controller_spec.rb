require 'spec_helper'

describe ProjectsController do
  render_views

  describe "GET 'index'" do

    describe "for non-logged-in users" do

      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
      end
    end

    describe "for logged-in users" do

      before(:each) do
        @user = test_log_in(Factory(:user))
        32.times do |n|
          @user.projects.create(:name => "Test Project #{n+1}", :client => "Test Client")
        end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All projects")
      end

      it "should have an element for each project" do
        get :index
        Project.all.paginate(:page => 1).each do |project|
          response.should have_selector("li", :content => project.name)
        end
      end

      it "should paginate projects" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/projects?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/projects?page=2",
                                           :content => "Next")
      end

      it "should have delete links for the project creator" do
        project = Project.all.first
        get :index
        response.should have_selector("a", :href => project_path(project),
                                           :content => "delete")
      end

      it "should have delete links for admins" do
        new_user = Factory(:user, :email => Factory.next(:email))
        new_user.toggle!(:admin)
        test_log_in(new_user)
        project = Project.all.first
        get :index
        response.should have_selector("a", :href => project_path(project),
                                           :content => "delete")
      end

      it "should not have delete links for non-admins/non-project creators" do
        new_user = Factory(:user, :email => Factory.next(:email))
        test_log_in(new_user)
        project = Project.all.first
        get :index
        response.should_not have_selector("a", :href => project_path(project),
                                               :content => "delete")
      end

    end
  end

  describe "GET 'show'" do

    describe "for non-logged-in users" do

      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
      end
    end

    describe "for logged-in users" do

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

  describe "GET 'new'" do

    before(:each) do
      test_log_in(Factory(:user))
    end

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Create project")
    end

  end

  describe "POST 'create'" do

    before(:each) do
      test_log_in(Factory(:user))
    end

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :client => "", :description => "", :image => "", :wiki => "", :issue_tracker => "" }
      end

      it "should have the right title" do
        post :create, :project => @attr
        response.should have_selector("title", :content => "Create project")
      end

      it "should render the 'new' page" do
        post :create, :project => @attr
        response.should render_template("new")
      end

      it "should not create a project" do
        lambda do
          post :create, :project => @attr
        end.should_not change(Project, :count)
      end
    end

    describe "success" do

    end
  end
end
