# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

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

    # Create account
    account = Account.new(name: "My Account")
    if account.save
        # Add user to account
        account_user = AccountUser.create(user_id: user.id, account_id: account.id, owner: true, role: :admin)
        # Create project
        project = Project.new(name: "My Project", account_id: account.id)
        if project.save
            p "*" * 50
            p "SAVED PROJECT"
            p "*" * 50
            form = CustomForm.new(name: "My Form", project_id: project.id)
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
else
    p "*" * 50
    p "ERROR SAVING EMILY"
    p user.errors.full_messages
    p "*" * 50
end