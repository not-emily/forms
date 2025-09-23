class AccountsController < ApplicationController
    before_action :authenticate_user
    before_action :user_accounts
    before_action :set_account, except: [:select_accounts, :select_accounts_do, :create_account_1, :create_account_1_do]
    layout 'auth'
    
    def select_accounts
        @accounts = AccountUser.for_user(@current_user.id)
        # The user automatically gets an account created for them if they don't have one.
        if @accounts.empty?
            p "*" * 50
            p "NO ACCOUNT YET"
            p "*" * 50
            if !@current_user.create_default_account()
                flash[:error] = "Oops! Something went wrong... Please sign in again."
                redirect_to signin_path
            end

            @accounts = AccountUser.for_user(@current_user.id)      # Update accounts since we just made a new one
        end

        p "*" * 50
        p "ACCOUNTS"
        p @accounts
        p @accounts.size
        p "*" * 50
        # @invites = AccountInvite.for_email(@current_user.email).pending
        # if @invites.empty?
        #     #There is just one, dont bother with the selection screen.
             if @accounts.size == 1
                p "*" * 50
                p "REDIRECTING"
                p @accounts[0].account.token
                p "*" * 50
                redirect_to do_select_accounts_path(@accounts[0].account.token)
             end
        # end
    end

    def select_accounts_do
        account = Account.find_by_token(params[:id])
        if account && account.active? #only allow active accounts
            session[:current_account] = account
            redirect_to projects_path
        else
            flash[:notice] = "There was a problem selecting that account"
            redirect_to select_accounts_path
        end
    end

    def create_account_1
    end

    def create_account_1_do
    end
end
