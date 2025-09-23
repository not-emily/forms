class User < ApplicationRecord
  attr_accessor :password, :password_confirmation, :new_password

  has_many :account_users, :dependent => :destroy

  validates_presence_of          :first_name

  validates_presence_of          :last_name

  validates_presence_of          :email

  validates_uniqueness_of        :email,
                                 on: [:create, :update],
                                 :allow_blank => true # when updating and not setting this

  validates_format_of            :email,
                                 :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i


  validates_presence_of          :password,
                                 :on => :create

  validates_confirmation_of      :password,
                                 :on => :create

  validates_confirmation_of      :password,
                                 :on => :update, :if => lambda {|password| password.present?}

  validates_length_of            :password,
                                 :on => :create,
                                 :minimum => 8

  validates_format_of            :password,
                                 :on => :create,
                                 :with => /\A(?=.*[a-zA-Z]).{6,}\Z/,
                                 :message => "is not secure enough."

  before_validation              :downcase_email

  before_validation              :set_apikey,
                                 :on => :create

  before_validation              :set_status,
                                 :on => :create

  before_create                  :encrypt_password
  before_update                  :encrypt_password

  #after_create                   :stripe_customer


  enum status: {
    active: "ACTIVE",
    inactive: "INACTIVE",
    pending: "PENDING",
    banned: "BANNED"
  }

  def name
    return "#{self.first_name} #{self.last_name}"
  end

  def generate_reset_token
    self.password_reset_key = "#{Time.now.to_i.to_s}-#{SecureRandom.uuid}"
  end

  def update_reset_token
    self.generate_reset_token
    self.save
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      return user
    else
      return nil
    end#if user
  end


  def self.from_gsi(payload)
    full_name = "#{payload['given_name']} #{payload['family_name']}"
    User.find_or_create_by(email: payload["email"], gsi_sub: payload["sub"]) do |u|
      u.email = payload["email"]
      u.gsi_sub = payload["sub"]
      u.first_name = payload["given_name"]
      u.last_name = payload["family_name"]
      u.gsi_pic = payload["picture"]
      u.password = SecureRandom.hex(15) #need to make one up to pass validation
      u.password_confirmation = u.password
    end
  end


  def create_default_account()
    account = Account.new(name: "Personal")
    if account.save
        u = AccountUser.new(account_id: account.id,
                            user_id: self.id,
                            owner: true,
                            role: :admin)
        if !u.save
            return false
        end
    else
        return false
    end

    return true
  end


  private


  def stripe_customer
    begin
      customer = Stripe::Customer.create({
        email: self.email
      })
      self.update(stripe_customer_id: customer.id)
    rescue => e
      self.errors.add(:stripe, "Stripe error: #{e}")
    end
  end


  def downcase_email
    self.email = self.email.downcase
  end

  #Creates a one-way hash and salt of the password.
  def encrypt_password #:doc:
    if password.present? && !new_password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    elsif new_password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(new_password, password_salt)
    end
  end


  ##
  #For creating a unique apikey.
  #
  #The apikey is used as an ID in admin view URLs .
  #
  #Will loop and create SecureRandom until it has a unique.
  def set_apikey #:doc:
    model = self.class.name.capitalize.constantize
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