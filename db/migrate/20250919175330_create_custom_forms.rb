class CreateCustomForms < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_forms do |t|
      t.string              :name
      t.integer             :project_id
      t.string              :description

      t.string              :apikey
      t.string              :status

      t.timestamps
      t.index :apikey
    end
  end
end
