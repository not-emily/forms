class CreateBillingOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_options do |t|
      t.integer     :plan_id
      t.string      :interval, null: false  # monthly, yearly
      t.integer     :price_cents, null: false
      t.string      :stripe_price_id

      t.timestamps
    end
    add_index :billing_options, [:plan_id, :interval], unique: true
  end
end
