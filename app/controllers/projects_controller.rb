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
end
