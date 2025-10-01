class CreateFormFieldChildren < ActiveRecord::Migration[7.1]
  def change
    create_table :form_field_children do |t|
      t.integer             :form_field_id
      t.string              :name
      t.string              :field_id
      t.integer             :order_num

      t.string              :apikey
      t.string              :status

      t.timestamps
      t.index :apikey
    end
  end
end
