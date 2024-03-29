require 'spec_helper'

describe UsersController do
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
        Factory(:user, :email => "user.one@example.com")
        Factory(:user, :email => "user.two@example.com")
        30.times { Factory(:user, :email => Factory.next(:email)) }
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end

      it "should have an element for each user" do
        get :index
        User.all.paginate(:page => 1).each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
      end

      it "should have delete links for admins" do
        @user.toggle!(:admin)
        other_user = User.all.second
        get :index
        response.should have_selector("a", :href => user_path(other_user),
                                           :content => "delete")
      end

      it "should not have delete links for non-admins" do
        other_user = User.all.second
        get :index
        response.should_not have_selector("a", :href => user_path(other_user),
                                               :content => "delete")
      end

    end

  end
  
  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
      test_log_in(@user)
    end
    
    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user.id
      response.should have_selector("title", :content => @user.name)
    end
    
    it "should have the user's name" do
      get :show, :id => @user.id
      response.should have_selector("h1", :content => @user.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user.id
      response.should have_selector("div>img", :class => "gravatar")
    end
    
    describe "when logged in as another user" do
      it "should be successful" do
        test_log_in(Factory(:user, :email => Factory.next(:email)))
        get :show, :id => @user
        response.should be_success
      end
    end
    
  end
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Register")
    end
  end

  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => "" }
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Register")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template("new")
      end
      
      it "should not create a user" do
        lambda do 
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "password", :password_confirmation => "password" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user 'show' page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to saffron/i
      end
      
      it "should log the user in" do
        post :create, :user => @attr
        controller.should be_logged_in
      end
      
    end
  end
  
  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_log_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit profile")
    end

    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      response.should have_selector("a", :href => "http://gravatar.com/emails",
                                         :content => "change")
    end

  end
  
  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_log_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit profile")
      end

    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New Name", :email => "new.user@example.com",
                  :password => "newpassword", :password_confirmation => "newpassword" }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        user = assigns(:user)
        @user.reload
        @user.name.should == user.name
        @user.email.should == user.email
        @user.encrypted_password.should == user.encrypted_password
      end

      it "should have a flash message" do
        post :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/i
      end

    end

  end

  describe "authentication of edit/update actions" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-logged in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(login_path)
      end

    end

    describe "for logged-in users" do

      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_log_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end

    end

  end
  
  describe "DELETE 'destroy" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "as a non-logged-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(login_path)
      end
    end
    
    describe "as a non-admin user" do
      it "should protect the action" do
        test_log_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an admin user" do
      
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_log_in(@admin)
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        flash[:success].should =~ /deleted/i
        response.should redirect_to(users_path)
      end
      
      it "should not be able to destroy itself" do
        lambda do
          delete :destroy, :id => @admin
        end.should_not change(User, :count)
      end
      
    end
    
  end
  
end
