class CreateSpools < ActiveRecord::Migration[8.1]
  def change
    create_table :spools do |t|
      t.references :variant, null: false, foreign_key: true
      t.integer :remaining_weight_gross, null: false
      t.boolean :ovp, null: false, default: false
      t.boolean :refill, null: false, default: false

      t.timestamps
    end
  end
end
