class AddNaturalColorSortKeyToFilaments < ActiveRecord::Migration[8.1]
  class MigrationFilament < ApplicationRecord
    self.table_name = "filaments"

    before_validation :sync_natural_color_sort_key

    def sync_natural_color_sort_key
      self.natural_color_sort_key = NaturalColorSortKey.for(color_hex: color_hex, color_name: color_name)
    end
  end

  def up
    add_column :filaments, :natural_color_sort_key, :string

    MigrationFilament.reset_column_information
    MigrationFilament.find_each(&:save!)

    change_column_null :filaments, :natural_color_sort_key, false
    add_index :filaments, :natural_color_sort_key
  end

  def down
    remove_index :filaments, :natural_color_sort_key
    remove_column :filaments, :natural_color_sort_key
  end
end
