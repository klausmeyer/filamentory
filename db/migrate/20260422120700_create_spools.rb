class CreateSpools < ActiveRecord::Migration[8.1]
  def change
    create_table :spools do |t|
      t.references :filament, null: false, foreign_key: true
      t.boolean :ovp, null: false, default: false
      t.boolean :refill_only, null: false, default: false
      t.integer :gross_weight_grams
      t.integer :remaining_weight_grams, null: false, default: 0
      t.string :comment

      t.timestamps
    end
  end
end

