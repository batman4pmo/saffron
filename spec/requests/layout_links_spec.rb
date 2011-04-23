require 'spec_helper'

describe "LayoutLinks" do
  
  it "should have a Home page at '/'" do
        get '/'
        response.should have_selector("title", :content => "Home")
  end
  
  it "should have a register page at '/register'" do
    get '/register'
    response.should have_selector("title", :content => "Register")
  end
  
  it "should have a login page at '/login'" do
    get '/login'
    response.should have_selector("title", :content => "Log in")
  end
  
  it "should have the right links on the layout" do
    visit root_path
    response.should have_selector("title", :content => "Home")
  end
  
  describe "when not logged in" do
    it "should have a log in link" do
      visit root_path
      response.should have_selector("a", :href => login_path,
                                         :content => "Log in")
    end  
  end
  
  describe "when logged in" do
    
    before(:each) do
      @user = Factory(:user)
      visit login_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end
    
    it "should have a log out link" do
      visit root_path
      response.should have_selector("a", :href => logout_path,
                                         :content => "Log out")
    end
    
    it "should have an edit profile link" do
      visit root_path
      response.should have_selector("a", :href => edit_user_path(@user),
                                         :content => "Profile")
    end
    
    it "should have a users link" do
      visit root_path
      response.should have_selector("a", :href => users_path,
                                         :content => "Users")
    end

    it "should have a projects link" do
      visit root_path
      response.should have_selector("a", :href => projects_path,
                                         :content => "Projects")
    end
    
  end
  
end