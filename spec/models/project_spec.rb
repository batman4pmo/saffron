require 'spec_helper'

describe Project do

  before(:each) do

    @user = Factory(:user)

    @attr = {
        :name          => "First Project",
        :client        => "My Client",
        :description   => "My first project for My client",
        :image         => "http://www.image.com/",
        :wiki          => "http://www.wiki.com/",
        :issue_tracker => "http://www.issues.com/",
    }
  end

  it "should create a new instance of a project given valid attributes" do
    @user.projects.create!(@attr)
  end

  describe "validations" do

    it "should require a user id" do
      Project.new(@attr).should_not be_valid
    end

    it "should require a name" do
      @user.projects.create(@attr.merge(:name => "")).should_not be_valid
    end

    it "should require a client" do
      @user.projects.create(@attr.merge(:client => "")).should_not be_valid
    end

    it "should reject blank names" do
      @user.projects.create(@attr.merge(:name => "  ")).should_not be_valid
    end

    it "should reject blank clients" do
      @user.projects.create(@attr.merge(:client => "  ")).should_not be_valid
    end

    it "should reject names that are too long" do
      long_name = "a" * 81
      long_name_project = @user.projects.create(@attr.merge(:name => long_name))
      long_name_project.should_not be_valid
    end

    it "should reject clients that are too long" do
      long_client = "a" * 81
      long_client_project = @user.projects.create(@attr.merge(:client => long_client))
      long_client_project.should_not be_valid
    end

    it "should reject descriptions that are too long" do
      long_description = "a" * 151
      long_description_project = @user.projects.create(@attr.merge(:description => long_description))
      long_description_project.should_not be_valid
    end
  end

  describe "user associations" do

    before(:each) do
      @project = @user.projects.create(@attr)
    end

    it "should have a user attribute" do
      @project.should respond_to(:user)
    end

    it "should have the right associated user" do
      @project.user_id.should == @user.id
      @project.user.should == @user
    end
  end
end
