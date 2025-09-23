class AccountUser < ApplicationRecord
    belongs_to :account
    belongs_to :user

    validates :user, uniqueness: { scope: :account , message: "already added"}

    before_validation               :set_status,
                                    :on => :create

    before_validation               :set_apikey,
                                    :on => :create

    before_validation               :set_token,
                                    :on => :create

    scope :for_user, ->(user) { where('user_id = ?', user) if user.present? }
    scope :for_account, ->(account) { where('account_id = ?', account) if account.present? }
    scope :for_owner, -> { where('owner = ?', true) }

    enum role: {
        admin: "ADMIN",
        user: "USER"
    }


    private

    ##
    #For creating a unique apikey.
    #
    #The apikey is used as an ID in admin view URLs .
    #
    #Will loop and create SecureRandom until it has a unique.
    def set_apikey #:doc:
        model = AccountUser
        begin
        self.apikey = SecureRandom.urlsafe_base64
        end while model.exists?(apikey: self.apikey)
    end

    ##
    #For creating a unique token.
    #
    #The token is used as the ID in client view URLs.
    #
    #Will loop and create SecureRandom until it has a unique.
    def set_token #:doc:
        model = AccountUser
        begin
        self.token = SecureRandom.uuid
        end while model.exists?(token: self.token)
    end


    def set_status
        self.status = "ACTIVE"
    end
end
