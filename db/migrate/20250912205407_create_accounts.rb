class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :subscription_key
      t.string :stripe_price_id
      t.string :apikey
      t.string :token
      t.string :status

      t.timestamps
    end
  end
end
