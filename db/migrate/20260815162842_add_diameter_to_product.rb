class AddDiameterToProduct < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :diameter, :decimal, null: false, default: 1.75
  end
end
