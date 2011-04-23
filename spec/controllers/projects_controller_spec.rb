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
          @user.projects.create(Factory(:project, :user => @user, :name => "Test Project #{n+1}"))
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
      response.should have_selector("title", :content => "New project")
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
        response.should have_selector("title", :content => "New project")
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

  describe "GET 'edit'" do

    before(:each) do
      user = Factory(:user)
      test_log_in(user)
      @project = user.projects.create(:name => "Test Project", :client => "Test Client")
    end

    it "should be successful" do
      get :edit, :id => @project
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @project
      response.should have_selector("title", :content => "Edit project")
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      user = Factory(:user)
      test_log_in(user)
      @project = user.projects.create(:name => "Test Project", :client => "Test Client")
    end

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :client => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @project, :project => @attr
        response.should render_template("edit")
      end

      it "should have the right title" do
        put :update, :id => @project, :project => @attr
        response.should have_selector("title", :content => "Edit project")
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New Project Name", :client => "New Client", :description => "New Description",
                  :image => "www.image.com",   :wiki => "www.wiki.com", :issue_tracker => "www.issues.com" }
      end

      it "should change the project's attributes" do
        put :update, :id => @project, :project => @attr
        project = assigns(:project)
        @project.reload
        @project.name.should          == project.name
        @project.client.should        == project.client
        @project.description.should   == project.description
        @project.image.should         == project.image
        @project.wiki.should          == project.wiki
        @project.issue_tracker.should == project.issue_tracker
      end

      it "should have a flash message" do
        put :update, :id => @project, :project => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end

  describe "authentication of edit/update actions" do

    before(:each) do
      user = Factory(:user)
      @project = user.projects.create(:name => "Test Project", :client => "Test Client")
    end

    describe "for non-logged in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @project
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end

      it "should deny access to 'update'" do
        put :update, :id => @project, :project => {}
        response.should redirect_to(login_path)
      end
    end

    describe "for logged-in users" do

      before(:each) do
        @wrong_user = Factory(:user, :email => "wrong.user@example.com")
        test_log_in(@wrong_user)
      end

      it "should require a matching user for 'edit'" do
        get :edit, :id => @project
        response.should redirect_to(root_path)
      end

      it "should require a matching user for 'update'" do
        put :update, :id => @project, :project => {}
        response.should redirect_to(root_path)
      end

      it "should allow an admin access to 'edit'" do
        @wrong_user.toggle!(:admin)
        get :edit, :id => @project
        response.should have_selector("title", :content => "Edit project")
      end

      it "should allow an admin access to 'update'" do
        @wrong_user.toggle!(:admin)
        put :update, :id => @project, :project => {:name => "New name", :client => "New client"}
        flash[:success].should =~ /updated/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
      @project = @user.projects.create(:name => "Test Project", :client => "Test Client")
    end

    describe "as a non-logged-in user" do
      it "should deny access" do
        delete :destroy, :id => @project
        response.should redirect_to(login_path)
      end
    end

    describe "as a non-admin/non-project owner" do
      it "should protect the action" do
        test_log_in(Factory(:user, :email => Factory.next(:email)))
        delete :destroy, :id => @project
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_log_in(@admin)
      end

      it "should destroy the project" do
        lambda do
          delete :destroy, :id => @project.id
        end.should change(Project, :count).by(-1)
      end

      it "should redirect to the projects page" do
        delete :destroy, :id => @project
        flash[:success].should =~ /deleted/i
        response.should redirect_to(projects_path)
      end
    end

    describe "as a project owner" do

      before(:each) do
        test_log_in(@user)
      end

      it "should destroy the project" do
        lambda do
          delete :destroy, :id => @project.id
        end.should change(Project, :count).by(-1)
      end

      it "should redirect to the projects page" do
        delete :destroy, :id => @project
        flash[:success].should =~ /deleted/i
        response.should redirect_to(projects_path)
      end
    end
  end
end