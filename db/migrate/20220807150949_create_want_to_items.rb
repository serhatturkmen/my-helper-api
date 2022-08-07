class CreateWantToItems < ActiveRecord::Migration[6.1]
  def change
    create_table :want_to_items do |t|
      t.string :name
      t.string :description
      t.string :url
      t.integer :position
      t.boolean :active, default: true
      t.references :want_to_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
