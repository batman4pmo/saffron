class ProjectsController < ApplicationController
  before_filter :authenticate

  def index
    @projects = Project.all.paginate(:page => params[:page])
    @title = "All projects"
  end

  def show
    @project = Project.find(params[:id])
    @title = @project.name
  end

  def new
    @project = Project.new
    @title = "New project"
  end

  def create
    @project = current_user.projects.create(params[:project])
    if @project.save
      redirect_to @project, :flash => {:success => "Project created!"}
    else
      @title = "New project"
      render 'new'
    end
  end
end
