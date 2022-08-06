class CreateWantToCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :want_to_categories do |t|
      t.string :name
      t.string :description
      t.string :color
      t.integer :position
      t.boolean :active, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
