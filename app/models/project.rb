class Project < ApplicationRecord
    belongs_to :account
    has_many :custom_forms, :dependent => :destroy

    before_validation              :set_apikey,
                                   :on => :create

    before_validation              :set_status,
                                   :on => :create


    enum status: {
        active: "ACTIVE",
        inactive: "INACTIVE"
    }

    private

    def set_apikey
        model = Project
        begin
        self.apikey = SecureRandom.urlsafe_base64
        end while model.exists?(apikey: self.apikey)
    end
    
    def set_status
        self.status = :active
    end
end
