class AccountsController < ApplicationController
    before_action :authenticate_user
    before_action :user_accounts
    before_action :set_account, except: [:select_accounts, :select_accounts_do, :create_account_1, :create_account_1_do, :select_plan, :select_plan_do]
    layout 'auth'
    
    def select_accounts
        @accounts = AccountUser.for_user(@current_user.id)
        # The user automatically gets an account created for them if they don't have one.
        if @accounts.empty?
            if !@current_user.create_default_account()
                flash[:error] = "Oops! Something went wrong... Please sign in again."
                redirect_to signin_path
            end

            @accounts = AccountUser.for_user(@current_user.id)      # Update accounts since we just made a new one
        end

        @invites = AccountInvite.for_email(@current_user.email).pending
        if @invites.empty?
            #There is just one, dont bother with the selection screen.
             if @accounts.size == 1
                redirect_to do_select_accounts_path(@accounts[0].account.token)
             end
        end
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
        if !params[:name].nil? && !params[:name].empty?
            account = Account.new(name: params[:name])
            if account.save
                u = AccountUser.new(account_id: account.id,
                                    user_id: @current_user.id,
                                    owner: true,
                                    role: "ADMIN")
                if u.save
                    session[:current_account] = account
                    redirect_to select_plan_path(account.token)
                else
                    flash[:error] = "Your account was created, but there was a problem adding you to it."
                    redirect_to create_account_1_path
                end
            else
                flash[:error] = "There was a problem creating your account. Please try again later."
                redirect_to create_account_1_path
            end
        else
            flash[:error] = "Please provide an account name."
            redirect_to create_account_1_path
        end
    end

    def create_account_2
        p "*" * 50
        p 'CREATE ACCOUNT 2 PATH'
        p "*" * 50
    end

    def create_account_2_do
    end

    def select_plan
        account = Account.find_by_token(params[:id])
        @plans = Plan.all
    end

    def select_plan_do
        account = Account.find_by_token(params[:account_token])
        plan = Plan.find_by_apikey(params[:plan_apikey])
        if account && plan
            account.update(plan_id: plan.id)
            # TODO: Capture payment
            redirect_to root_path
        else
            flash[:notice] = "There was a problem selecting that plan"
            redirect_to select_plan_path
        end
    end

    def accept_invite
        invite = AccountInvite.find_by_apikey(params[:invite_apikey])
        if invite
            accepted = invite.accept_invite
            if accepted
                flash[:notice] = "Successfully joined the #{invite.account.name} account!"
            else
                flash[:error] = "Unable to join the #{invite.account.name} account. Please try again later."
            end
        else
            flash[:error] = "Unable to accept invite. Invite not found."
        end
        redirect_to account_selection_path
    end
    
    def decline_invite
        invite = AccountInvite.find_by_apikey(params[:invite_apikey])
        if invite
            declined = invite.decline_invite
            if declined
                flash[:notice] = "Successfully declined invitation"
            else
                flash[:error] = "Unable to decline the invitation. Please try again later."
            end
        else
            flash[:error] = "Unable to decline invite. Invite not found."
        end
        redirect_to account_selection_path
    end

end
