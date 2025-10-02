module AccountsHelper
    def list_accounts
        if @accounts.empty?
        @product_count = 0
        '<div class="mt-5 mb-3"><p>There are no accounts yet. Create one below, or ask someone to invite you to their account.</p></div>'.html_safe
        else
        render partial: "account_list"
        end #if/else

    end # list_accounts
end
