class CreateAccountUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :account_users do |t|
      t.integer :account_id
      t.integer :user_id
      t.string  :status
      t.string  :role
      t.boolean  :owner
      t.string  :apikey
      t.string  :token

      t.timestamps
    end
    add_index :account_users, [:user_id, :account_id], unique: true
  end
end
