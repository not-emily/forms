class CreateAccountInvites < ActiveRecord::Migration[7.1]
  def change
    create_table :account_invites do |t|
      t.integer   :account_id
      t.integer   :user_id
      t.string    :email
      t.string    :role
      t.string    :status
      t.string    :apikey
      t.string    :token

      t.timestamps
    end
  end
end
