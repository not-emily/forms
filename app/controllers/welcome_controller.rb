class WelcomeController < ApplicationController
    layout 'auth'

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
        user = User.new(first_name: params[:first_name],
                        last_name: params[:last_name],
                        email: params[:email],
                        password: params[:password],
                        password_confirmation: params[:password_confirmation])

        if user.save
            session[:current_user] = user
            session[:user_id] = user.apikey
            session[:expiry_time] = Time.current.to_s
            #update the user
            #send the welcome email
            #ProfileMailer.with(user: user, base_url: Figaro.env.base_url).welcome.deliver_now
            redirect_to select_accounts_path
        else
            p user.errors.full_messages
            flash[:notice] = "Oops. #{user.errors.full_messages}"
            redirect_to signup_path
        end
    end

    def signout
        reset_session
        flash[:notice] = "You are signed out"
        redirect_to signin_path
    end
end
