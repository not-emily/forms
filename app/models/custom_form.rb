class CustomForm < ApplicationRecord
    belongs_to :project
    has_many :form_fields
    has_many :form_submissions

    validates :name, presence: true

    before_validation              :set_apikey,
    :on => :create

    before_validation              :set_status,
    :on => :create

    enum status: {
        active: "ACTIVE",
        inactive: "INACTIVE"
    }


    private
    ##
    #For creating a unique apikey.
    #
    #The apikey is used as an ID in admin view URLs .
    #
    #Will loop and create SecureRandom until it has a unique.
    def set_apikey #:doc:
        model = CustomForm
        begin
        self.apikey = SecureRandom.urlsafe_base64
        end while model.exists?(apikey: self.apikey)
    end
    
    
    ##
    #Default status for new user creation
    def set_status #:doc:
        self.status = :active
    end
end
