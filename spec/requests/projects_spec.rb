require "spec_helper"

describe "Projects" do

  describe "new project" do

    before(:each) do
      user = Factory(:user)
      visit login_path
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button
    end

    describe "failure" do
      it "should not create a new project" do
        lambda do
          visit "projects/new"
          fill_in "Name",   :with => ""
          fill_in "Client", :with => ""
          click_button
          response.should render_template("projects/new")
          response.should have_selector("div#error_explanation")
        end.should_not change(Project, :count)
      end
    end
  end
end