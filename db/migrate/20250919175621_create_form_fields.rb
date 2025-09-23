class CreateFormFields < ActiveRecord::Migration[7.1]
  def change
    create_table :form_fields do |t|
      t.integer             :custom_form_id
      t.string              :name
      t.string              :field_id
      t.string              :field_type
      t.integer             :col_width
      t.boolean             :required,                  :default => false
      t.string              :placeholder
      t.boolean             :label_as_placeholder,      :default => false
      t.integer             :order_num

      t.string              :apikey
      t.string              :status

      t.timestamps
      t.index :apikey
    end
  end
end
