class ProjectsController < ApplicationController
    before_action :authenticate_user
    before_action :user_accounts
    before_action :set_account
    before_action :set_breadcrumbs
    layout 'dashboard'

    def index
        @projects = @current_account.projects
        @users = @current_account.users
        # TODO: Make this more interesting
        @featured_project = @projects.first
        @show_plan_upgrade = !@current_account.plan.business?
    end

    def show
        @project = Project.find_by_apikey(params[:project_apikey])
        @forms = @project.custom_forms
        add_breadcrumb(@project.name)
    end

    def new
    end

    def create
        project = Project.new(name: params[:name], description: params[:description], account_id: @current_account.id)
        if project.save
            flash[:success] = "Project created successfully."
            redirect_to show_project_path(project.apikey)
        else
            flash[:error] = "Error creating project."
            redirect_to new_project_path
        end
    end

    private

    def set_breadcrumbs
        add_breadcrumb(@current_account.name, root_path)
    end
end
