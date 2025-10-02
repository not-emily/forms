module UsersHelper
    def new_invite
        if @current_account.users.count >= @current_account.plan.users_count
        "<div class='mt-0 mb-3'><p class='fw-semibold fs-5 mb-8'>Oops! Looks like you have reached the maximum number of users with your #{@current_account.plan.name} plan.</p><a href='#{select_plan_path(@current_account.token)}' class='btn btn-sm btn-primary'>Upgrade now</a></div>".html_safe
        else
        render partial: "invite_form"
        end #if/else
    end
end
