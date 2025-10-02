class Account < ApplicationRecord
  belongs_to :plan, optional: true
  has_many :account_users, :dependent => :destroy
  has_many :users, :through => :account_users
  has_many :projects, :dependent => :destroy
  has_many :custom_forms, :through => :projects
  has_many :form_submissions, :through => :custom_forms

  has_one_attached :logo

  validates :name, presence: true

  before_validation             :set_status,
                                :on => :create

  before_validation             :set_apikey,
                                :on => :create

  before_validation             :set_token,
                                :on => :create

  ##
  #ACTIVE = Account is available for use.
  #
  #DISABLED = When payment fails, we will disable the account.
  enum status: {
    active: "ACTIVE",
    inactive: "INACTIVE"
  }

  def owner
    return AccountUser.for_account(self.id).find_by_owner(true).user
  end

  private

  ##
  #For creating a unique apikey.
  #
  #The apikey is used as the ID in admin view URLs.
  #
  #Will loop and create SecureRandom until it has a unique.
  def set_apikey #:doc:
    model = self.class.name.capitalize.constantize
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
    model = self.class.name.capitalize.constantize
    begin
      self.token = SecureRandom.uuid
    end while model.exists?(token: self.token)
  end


  def set_status
    self.status = :active
  end
end