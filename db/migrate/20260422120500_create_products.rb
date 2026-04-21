class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.references :brand, null: false, foreign_key: true
      t.references :material, null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true
      t.integer :spool_weight_grams, null: false
      t.integer :weight_grams, null: false

      t.timestamps
    end

    add_index :products, :name, unique: true
  end
end

