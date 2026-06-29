class AddDiameterToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :diameter, :decimal, precision: 4, scale: 2, null: false, default: "1.75"
  end
end
