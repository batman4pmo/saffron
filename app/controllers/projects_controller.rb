class ProjectsController < ApplicationController
  before_filter :authenticate

  def show
    @project = Project.find(params[:id])
    @title = @project.name
  end
end
