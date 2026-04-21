class CreateFilaments < ActiveRecord::Migration[8.1]
  def change
    create_table :filaments do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name, null: false
      t.string :color_name, null: false
      t.string :color_hex, null: false

      t.timestamps
    end
  end
end

