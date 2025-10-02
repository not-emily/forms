class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.integer :account_id
      t.string  :name
      t.string  :description
      t.string  :apikey
      t.string  :status

      t.timestamps
      t.index   :apikey
    end
  end
end
