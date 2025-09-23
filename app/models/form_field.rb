class FormField < ApplicationRecord
    belongs_to :custom_form
    # has_many :form_field_children

    before_validation              :set_apikey,
                                   :on => :create

    before_validation              :set_status,
                                   :on => :create

    before_validation              :set_order_num, 
                                   :on => :create

    before_validation              :set_field_id, 
                                   :on => :create


    default_scope { order(order_num: :asc) }
    scope :for_form, ->(form) { where('custom_form_id = ?', form) if form.present? }

    enum status: {
        active: "ACTIVE",
        inactive: "INACTIVE"
    }

    TYPES = {
        "short_text" => {
            :name => "Short Text",
            :element => "input",
            :element_type => "text",
            :has_children => false
        },
        "long_text" => {
            :name => "Long Text",
            :element => "textarea",
            :element_type => "",
            :has_children => false
        },
        "number" => {
            :name => "Number",
            :element => "input",
            :element_type => "number",
            :has_children => false
        },
        "phone" => {
            :name => "Phone",
            :element => "input",
            :element_type => "tel",
            :has_children => false
        },
        "email" => {
            :name => "Email",
            :element => "input",
            :element_type => "email",
            :has_children => false
        },
        "password" => {
            :name => "Password",
            :element => "input",
            :element_type => "password",
            :has_children => false
        },
        "radio" => {
            :name => "Radio buttons (Single select)",
            :element => "input",
            :element_type => "radio",
            :has_children => true
        },
        "checkbox" => {
            :name => "Checkboxes (Multi-select)",
            :element => "input",
            :element_type => "checkbox",
            :has_children => true
        },
        "date" => {
            :name => "Date",
            :element => "input",
            :element_type => "date",
            :has_children => false
        },
        "file" => {
            :name => "File upload",
            :element => "input",
            :element_type => "file",
            :has_children => false
        },
        "select" => {
            :name => "Dropdown",
            :element => "select",
            :element_type => "",
            :has_children => true
        },
    }

    private
    ##
    #For creating a unique apikey.
    #
    #The apikey is used as an ID in admin view URLs .
    #
    #Will loop and create SecureRandom until it has a unique.
    def set_apikey #:doc:
        model = FormField
        begin
        self.apikey = SecureRandom.urlsafe_base64
        end while model.exists?(apikey: self.apikey)
    end
    
    
    ##
    #Default status for new user creation
    def set_status #:doc:
        self.status = :active
    end

    def set_order_num
        self.order_num = FormField.for_form(self.custom_form_id).all.count + 1
    end

    # TODO: Make this unique to the field
    def set_field_id
        self.field_id = self.name.downcase.gsub(" ", "_")
    end
end
