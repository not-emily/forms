class UsersController < ApplicationController
    before_action :authenticate_user
    before_action :user_accounts
    before_action :set_account, except: [:accept_invite, :decline_invite]
    before_action :set_breadcrumbs, only: [:show, :edit, :new, :invites]
    layout 'dashboard'

    # ==============================================================
    #   INDEX
    #   get /users
    # ==============================================================
    def index
        add_breadcrumb(@current_account.name, root_path)
        add_breadcrumb("Users")
        @users = @current_account.users
        @pending_invites_count = AccountInvite.for_account(@current_account.id).pending.count
    end

    # ==============================================================
    #   SHOW
    #   get /users/:user_apikey
    # ==============================================================
    def show
        @user = User.find_by_apikey(params[:user_apikey])
        add_breadcrumb(@user.name)
    end

    # ==============================================================
    #   EDIT
    #   get /users/:user_apikey/edit
    # ==============================================================
    def edit
        @user = User.find_by_apikey(params[:user_apikey])
        add_breadcrumb("Editing #{@user.name}")
    end

    def new
        add_breadcrumb("Invite User")
    end

    def new_do
        # Check to see if user is already in the account
        user = @current_account.users.find_by_email(params[:email])
        if !user.nil?
            flash[:alert] = "#{user.name} is already a member of this account. <a href='#{show_user_path(user.apikey)}'>View Profile</a>"
            redirect_to new_user_path
            return
        end

        # Create invite
        # TODO: Add role in later
        account_invite = AccountInvite.new(account_id: @current_account.id, email: params[:email], from_user: @current_user)
        if account_invite.save
            #InviteMailer.with(email: params[:email],
            #                  base_url: Figaro.env.base_url,
            #                  account: session[:current_account]["id"],
            #                  from_user: session[:current_user]["id"]).add_guest.deliver_now
            flash[:success] = "Your invite has been sent."
        else
            flash[:notice] = account_invite.errors.full_messages
        end

        redirect_to users_path
    end


    def invites
        add_breadcrumb("Invites")
        @invites = AccountInvite.for_account(@current_account.id).pending
    end

    def remove_invite
        invite = AccountInvite.find_by_apikey(params[:invite_apikey])
        invite.destroy if invite
        flash[:notice] = "Invite has been removed"
        redirect_to invites_path
    end

    def resend_invite
        invite = AccountInvite.find_by_apikey(params[:invite_apikey])
        #InviteMailer.with(email: params[:email],
        #                  base_url: Figaro.env.base_url,
        #                  account: session[:current_account]["id"],
        #                  from_user: session[:current_user]["id"]).add_guest.deliver_now
        flash[:success] = "Your invite has been re-sent."
        redirect_to invites_path
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
        redirect_to select_accounts_path
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
        redirect_to select_accounts_path
    end

    private
    
    def set_breadcrumbs
        add_breadcrumb(@current_account.name, root_path)
        add_breadcrumb("Users", users_path)
    end
end
