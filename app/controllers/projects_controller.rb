class ProjectsController < ApplicationController
    before_action :authenticate_user
    before_action :user_accounts
    before_action :set_account
    layout 'dashboard'

    def index
    end

    def show
        @project = Project.find_by_apikey(params[:project_apikey])
        @forms = @project.custom_forms
    end

end
