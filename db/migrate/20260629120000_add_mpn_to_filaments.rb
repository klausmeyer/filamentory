class AddMpnToFilaments < ActiveRecord::Migration[8.1]
  def change
    add_column :filaments, :mpn, :string
  end
end
