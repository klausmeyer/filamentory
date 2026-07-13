class AddInventoryTagToSpool < ActiveRecord::Migration[8.1]
  def change
    add_column :spools, :inventory_tag, :string, null: true
    add_index :spools, "lower(inventory_tag)", unique: true
  end
end
