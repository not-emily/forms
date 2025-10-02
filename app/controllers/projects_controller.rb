class ProjectsController < ApplicationController
    before_action :authenticate_user
    before_action :user_accounts
    before_action :set_account
    before_action :set_breadcrumbs
    layout 'dashboard'

    def index
    end

    def show
        @project = Project.find_by_apikey(params[:project_apikey])
        @forms = @project.custom_forms
        add_breadcrumb(@project.name)
    end

    private

    def set_breadcrumbs
        add_breadcrumb(@current_account.name, root_path)
    end
end
