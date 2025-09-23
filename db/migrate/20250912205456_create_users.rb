class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string      :first_name
      t.string      :last_name
      t.string      :email
      t.string      :mobile
      t.string      :password_hash
      t.string      :password_salt
      t.string      :password_reset_key
      t.datetime    :password_reset_expires
      t.datetime    :last_active,             default: -> { 'CURRENT_TIMESTAMP' }
      t.string      :address1
      t.string      :address2
      t.string      :city
      t.string      :state
      t.string      :postal
      t.string      :gsi_pic
      t.string      :gsi_sub
      t.string      :apikey
      t.string      :status

      t.timestamps
      t.index :apikey
    end
  end
end
