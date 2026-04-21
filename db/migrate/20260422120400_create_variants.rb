class CreateVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :variants do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :variants, :name, unique: true
  end
end

