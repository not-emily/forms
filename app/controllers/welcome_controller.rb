class WelcomeController < ApplicationController
    layout 'auth'

    def index
    end

    def signin
    end

    def signin_do
        user = User.authenticate(params[:email], params[:password])
        if user
            session[:current_user] = user
            session[:user_id] = user.apikey
            session[:expiry_time] = Time.current.to_s
            # if user == "FAILED" #Catch for 2FA fail
            #     page = error_path
            # else
            #     #page = dashboard_path
            #     page = account_selection_path
            # end
            redirect_to select_accounts_path
        else
            flash[:error] = "Your email or password was incorrect."
            redirect_to signin_path
        end
    end

    def signup
    end

    def signup_do
    end

    def signout
        reset_session
        flash[:notice] = "You are signed out"
        redirect_to signin_path
    end
end
