class AccountInvite < ApplicationRecord
  belongs_to :account
  belongs_to :from_user, class_name: "User", foreign_key: "user_id"


  validates_presence_of         :account

  validates_presence_of         :email

  # validates :email, uniqueness: { scope: :account , message: "already invited"}
  validate :unique_email_for_active_invites, on: :create

  validates_format_of           :email,
                                :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  before_validation             :set_apikey,
                                :on => :create

  before_validation             :set_token,
                                :on => :create

  before_validation             :set_status,
                                :on => :create


  scope :for_email, ->(email) { email.present? ? where(email: email) : none }
  scope :for_status, ->(status) { status.present? ? where(status: status) : none }

  scope :for_account, ->(account) { account.present? ? where(account_id: account) : none }


  enum status: {
    pending: "PENDING",
    accepted: "ACCEPTED",
    declined: "DECLINED"
  }


  def accept_invite
    user = User.find_by_email(self.email)
    if user
      account_user = AccountUser.new(account_id: self.account_id, user_id: user.id, owner: false, role: self.role)
      if account_user.save
        return update(status: :accepted)
      end
    end
    return false
  end

  def decline_invite
    return update(status: :declined)
  end

  private

  def unique_email_for_active_invites
    if AccountInvite
        .where(account_id: account_id, email: email)
        .where(status: [:pending, :accepted])
        .where.not(id: id) # ignore self when updating
        .exists?
      errors.add(:email, "has already been invited to this account")
    end
  end


  def set_status
    self.status = :pending
  end

  ##
  #For creating a unique apikey.
  #
  #The apikey is used as an ID in admin view URLs .
  #
  #Will loop and create SecureRandom until it has a unique.
  def set_apikey #:doc:
    model = AccountInvite
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
    model = AccountInvite
    begin
      self.token = SecureRandom.uuid
    end while model.exists?(token: self.token)
  end
end