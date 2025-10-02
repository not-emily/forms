# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def create_plans
    plans = [
        {
            slug: "developer",
            name: "Developer",
            price_cents: 0000,
            submissions_per_month: 100,
            emails_per_month: 150,
            forms_count: 3,
            users_count: 1,
            features: {
                "custom_redirect" => false,
                "file_uploads" => false,
                "custom_smtp" => false,
                "autoresponders" => false,
                "webhooks" => false
            }
        },
        {
            slug: "basic",
            name: "Basic",
            price_cents: 700,
            submissions_per_month: 5000,
            emails_per_month: 2000,
            forms_count: -1,
            users_count: 5,
            features: {
                "custom_redirect" => true,
                "file_uploads" => false,
                "custom_smtp" => false,
                "autoresponders" => false,
                "webhooks" => false
            }
        },
        {
            slug: "business",
            name: "Business",
            price_cents: 2900,
            submissions_per_month: 25000,
            emails_per_month: 10000,
            forms_count: -1,
            users_count: -1,
            features: {
                "custom_redirect" => true,
                "file_uploads" => true,
                "custom_smtp" => true,
                "autoresponders" => true,
                "webhooks" => true
            }
        },
    ]
    plans.each do |plan|
        p = Plan.new(
            slug: plan[:slug],
            name: plan[:name],
            submissions_per_month: plan[:submissions_per_month],
            emails_per_month: plan[:emails_per_month],
            forms_count: plan[:forms_count],
            users_count: plan[:users_count],
            features: plan[:features]
        )
        if p.save
            # Assign billing options
            BillingOption.create!(
                plan_id: p.id,
                interval: :monthly,
                price_cents: plan[:price_cents]
            )
            BillingOption.create!(
                plan_id: p.id,
                interval: :yearly,
                price_cents: plan[:price_cents] * 12
            )
        end
    end
end

def create_account(user, plan)
    account = Account.new(name: "#{plan.name} Account", plan_id: plan.id)
    if account.save
        # Add user to account
        account_user = AccountUser.create(user_id: user.id, account_id: account.id, owner: true, role: :admin)
        # Create project
        project = Project.new(name: "My #{plan.name} Project", account_id: account.id)
        if project.save
            p "*" * 50
            p "SAVED #{plan.name.upcase} PROJECT"
            p "*" * 50
            form = CustomForm.new(name: "My #{plan.name} Form", project_id: project.id)
            if form.save
                field = FormField.new(custom_form_id: form.id, name: "Email", field_type: "email")
                if field.save
                    p "*" * 50
                    p "SAVED FORM FIELD"
                    p "*" * 50
                else
                    p "*" * 50
                    p "ERROR SAVING FORM FIELD"
                    p field.errors.full_messages
                    p "*" * 50
                end
            else
                p "*" * 50
                p "ERROR SAVING CUSTOM FORM"
                p form.errors.full_messages
                p "*" * 50
            end
        end
    end
end

user = User.new(
    first_name: "Emily",
    last_name: "Farley",
    email: "emily@pxp200.com",
    password: "asdfasdf",
    password_confirmation: "asdfasdf"
    )

if user.save
    p "*" * 50
    p "SAVED EMILY"
    p "*" * 50

    create_plans()

    Plan.all.each do |plan|
        create_account(user, plan)
    end
else
    p "*" * 50
    p "ERROR SAVING EMILY"
    p user.errors.full_messages
    p "*" * 50
end
