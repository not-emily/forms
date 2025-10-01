class FormFieldChild < ApplicationRecord
    belongs_to :form_field

    before_validation              :set_apikey,
                                   :on => :create

    before_validation              :set_status,
                                   :on => :create

    before_validation              :set_order_num, 
                                   :on => :create

    before_validation              :set_field_id, 
                                   :on => :create

    scope :for_form_field, ->(form_field) { where('form_field_id = ?', form_field) if form_field.present? }

    private
    ##
    #For creating a unique apikey.
    #
    #The apikey is used as an ID in admin view URLs .
    #
    #Will loop and create SecureRandom until it has a unique.
    def set_apikey #:doc:
        model = FormFieldChild
        begin
        self.apikey = SecureRandom.urlsafe_base64
        end while model.exists?(apikey: self.apikey)
    end
    
    
    ##
    #Default status for new user creation
    def set_status #:doc:
        self.status = "ACTIVE"
    end

    def set_order_num
        self.order_num = FormFieldChild.for_form_field(self.form_field_id).all.count + 1
    end

    def set_field_id
        self.field_id = self.name.downcase.gsub(" ", "_")
    end

end