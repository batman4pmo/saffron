class ProjectsController < ApplicationController
  before_filter :authenticate
  before_filter :project_owner, :only => [:edit, :update, :destroy]

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

  def edit
    @project = Project.find(params[:id])
    @title = "Edit project"
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to @project, :flash => {:success => "Project updated."}
    else
      @title = "Edit project"
      render 'edit'
    end
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    redirect_to projects_path, :flash => {:success => "Project deleted."}
  end

  private
  def project_owner
    project = Project.find(params[:id])
    redirect_to(root_path) unless current_user.admin? || current_user.id == project.user_id
  end
end