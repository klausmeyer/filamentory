class CreateFilaments < ActiveRecord::Migration[8.1]
  def change
    create_table :filaments do |t|
      t.string :name, null: false, index: true
      t.references :brand, null: false, foreign_key: true
      t.references :material, null: false, foreign_key: true

      t.timestamps
    end
  end
end
