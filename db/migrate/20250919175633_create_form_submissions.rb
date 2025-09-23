class CreateFormSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :form_submissions do |t|
      t.integer             :custom_form_id
      t.string              :raw_data

      t.string              :apikey
      t.string              :status

      t.timestamps
      t.index :apikey
    end
  end
end
