class FormSubmission < ApplicationRecord
    belongs_to :custom_form

    before_validation               :set_apikey,
                                    :on => :create

    before_validation               :set_status,
                                    :on => :create


    def name
        "Submission ##{self.id}"
    end

    def data
        JSON.parse(self.raw_data).map {|d| { "id" => d[0] }.merge(**JSON.parse(d[1].gsub("=>", ":")))}
    end


    private
    ##
    #For creating a unique apikey.
    #
    #The apikey is used as an ID in admin view URLs .
    #
    #Will loop and create SecureRandom until it has a unique.
    def set_apikey #:doc:
        model = FormSubmission
        begin
        self.apikey = SecureRandom.urlsafe_base64
        end while model.exists?(apikey: self.apikey)
    end
    
    
    ##
    #Default status for new user creation
    def set_status #:doc:
        self.status = "ACTIVE"
    end
end
