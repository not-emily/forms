class CustomFormsController < ApplicationController
    before_action :authenticate_user
    before_action :user_accounts
    before_action :set_account
    before_action :set_breadcrumbs
    layout 'dashboard'

    #
    # Custom Forms
    #
    def index
        project = Project.find_by_apikey(params[:project_apikey])
        @forms = project.forms
    end

    def show
        @form = CustomForm.find_by_apikey(params[:form_apikey])
        @form_fields = FormField.for_form(@form.id).order(order_num: :asc)
        add_breadcrumb(@form.name)

    end

    def new
        @form = CustomForm.new()
    end

    def create
        project = Project.find_by_apikey(params[:project_apikey])
        if project
            form = CustomForm.new(name: params[:form_name], description: params[:form_description], project_id: project.id)
            if form.save
                flash[:success] = "Form saved."
                redirect_to show_form_path(project.apikey, form.apikey)
            else
                p "*" * 50
                p "ERROR"
                p "*" * 50
                flash[:error] = "Couldn't save form. #{form.errors.full_messages}"
            end
        else
            p "*" * 50
            p "ERROR"
            p "*" * 50
            flash[:error] = "Couldn't find project."
        end
    end

    def edit
        @form = CustomForm.find_by_apikey(params[:form_apikey])
    end

    def update
        form = CustomForm.find_by_apikey(params[:form_apikey])
        form.name = params[:form_name]

        if form && form.save
            flash[:success] = "Form updated."
            redirect_to admin_custom_forms_path
        else
            p "*" * 50
            p "ERROR"
            p "*" * 50
            flash[:error] = "Couldn't save form. #{form.errors.full_messages}"
        end
    end

    #
    # Form Fields
    #
    def new_form_field
        @form = CustomForm.find_by_apikey(params[:form_apikey])
        @form_field = FormField.new()
    end

    def create_form_field
        project = Project.find_by_apikey(params[:project_apikey])
        form = CustomForm.find_by_apikey(params[:form_apikey])
        if form && project
            form_field = FormField.new(form_field_params.merge(:custom_form_id => form.id))

            if form_field.save
                field_children = params[:form_children]
                if field_children
                field_children.each do |child|
                    field_child = FormFieldChild.create(:name => child[1], :form_field_id => form_field.id)
                    p field_child
                end
                end

                flash[:success] = "Form field saved."
                redirect_to show_form_path(project.apikey, form.apikey) + "#form-builder"
            else
                p "*" * 50
                p "ERROR"
                p "*" * 50
                flash[:error] = "Couldn't save form field. #{form_field.errors.full_messages}"
            end
        else
            flash[:error] = "Couldn't find form. #{form.errors.full_messages}"
        end
    end

    def edit_form_field
        @form = CustomForm.find_by_apikey(params[:form_apikey])
        @field = FormField.find_by_apikey(params[:form_field_apikey])
        add_breadcrumb(@form.name, show_form_path(params[:project_apikey], @form.apikey))
        add_breadcrumb('Edit form field')
    end

    def update_form_field
        project = Project.find_by_apikey(params[:project_apikey])
        form = CustomForm.find_by_apikey(params[:form_apikey])
        form_field = FormField.find_by_apikey(params[:form_field_apikey])
        if form_field && form && project
            if form_field.update(form_field_params.merge(:custom_form_id => form.id))
                field_children = params[:form_children]
                if field_children
                    field_children.each do |child|
                        field_child = FormFieldChild.create(:name => child[1], :form_field_id => form_field.id)
                        p field_child
                    end
                end

                flash[:success] = "Form field saved."
                redirect_to show_form_path(project.apikey, form.apikey) + "#form-builder"
            else
                p "*" * 50
                p "ERROR"
                p "*" * 50
                flash[:error] = "Couldn't save form field. #{form_field.errors.full_messages}"
            end
        else
            flash[:error] = "Couldn't find form. #{form.errors.full_messages}"
        end
    end
    
    def destroy_form_field
        project = Project.find_by_apikey(params[:project_apikey])
        form = CustomForm.find_by_apikey(params[:form_apikey])
        field = FormField.find_by_apikey(params[:form_field_apikey])
        if field.destroy
            flash[:success] = "Form field deleted."
            redirect_to show_form_path(project.apikey, form.apikey) + "#form-builder"
        end
    end

    def reorder_form_fields
        items = parse_md_array(params[:items_order])

        # Update curriculum with new order
        items.each do |f|
        form_field = FormField.find_by_apikey(f[0])
        if (form_field && form_field.order_num != f[1])
            form_field.update(:order_num => f[1])
        end
        end

        # Refresh page to update preview - not ideal, but the javascript gets messy quickly here.. maybe later.
        redirect_to admin_show_custom_form_path(params[:form_apikey])
    end

    #
    # Form Submissions
    #
    def show_form_submission
        @submission = FormSubmission.find_by_apikey(params[:form_submission_apikey])

        @data = @submission.data
    end

    private

    def set_breadcrumbs
        add_breadcrumb(@current_account.name, root_path)
        project = Project.find_by_apikey(params[:project_apikey])
        add_breadcrumb(project.name, show_project_path(project.apikey))
    end

    def form_field_params
        params.permit(:name, :field_type, :col_width, :required, :placeholder, :label_as_placeholder)
    end

    # Parse string to multi-dimentional array
    def parse_md_array(string)
        items = string.gsub(/\[\[|\]\]/, '').split(/\], \[/)
        new_items = []
        items.each do |item|
        new_items << item.split(", ")
        end

        return new_items
    end
end
