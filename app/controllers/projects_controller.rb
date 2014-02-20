class ProjectsController < ApplicationController
	before_filter :authenticate_user!
	layout 'project'
	#This method used for get the projects
	def index
		@user_projects = current_user.projects
	end
	def new
	end
	#This method used for create a new project
	def create
	 project=current_user.projects.new(params[:project])
	 if project.save
	    redirect_to projects_path
	 else
      @errors = project.errors
	  	render :new
	 end
	end
   #This method used for edit the project details
   def edit
   	@project = Project.find(params[:id])
   end
   #This method used for display a project detail
   def show
   	@project = Project.find(params[:id])
   end
   #This method used for update the project detail
   def update
   	 @project = Project.find(params[:id])
   	 if @project.update_attributes(params[:project])
   	 	redirect_to projects_path
   	 else
         @errors = @project.errors
   	 	render :edit
   	 end
   end
   #This method used for delete a project record
   def destroy
   	 project = Project.find(params[:id])
   	 project.destroy
   	 redirect_to projects_path
   end

end
