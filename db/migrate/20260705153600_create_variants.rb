class CreateVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :variants do |t|
      t.string :name, null: false, index: { unique: true }
      t.references :filament, null: false, foreign_key: true
      t.integer :weight_net, null: false
      t.integer :weight_tare, null: false
      t.string :color, null: false

      t.timestamps
    end
  end
end
