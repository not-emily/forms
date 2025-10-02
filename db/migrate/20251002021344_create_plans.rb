class CreatePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :plans do |t|
      t.string        :slug
      t.string        :name
      t.integer       :submissions_per_month
      t.integer       :emails_per_month
      t.integer       :forms_count
      t.integer       :users_count
      t.jsonb         :features, default: {}
      t.string        :apikey

      t.index         :apikey
      t.timestamps
    end
  end
end
