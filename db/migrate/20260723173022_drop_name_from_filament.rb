class DropNameFromFilament < ActiveRecord::Migration[8.1]
  def change
    remove_column :filaments, :name, :string
  end
end
