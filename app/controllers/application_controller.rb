class ApplicationController < ActionController::Base
    def user_accounts
        @accounts_for_user = AccountUser.for_user(@current_user.id)
    end

    def set_account
        @current_account = Account.find(session[:current_account]["id"])
        @projects = @current_account.projects
    end

    def authenticate_user
        if session[:user_id] && session[:expiry_time]
            if session[:expiry_time] >= 30.minutes.ago.to_s
                session[:expiry_time] = Time.current.to_s
                @current_user = User.find_by_apikey(session[:user_id])
            else
                @current_user = User.find_by_apikey(session[:user_id])
                session[:user_id] = nil
                session[:current_user] = nil
                redirect_to signin_path
            end
        else
            redirect_to signin_path
        end
    end
end
