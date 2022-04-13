class AddColumnsToProperties < ActiveRecord::Migration[6.1]
  def change
    remove_column :properties, :address
    rename_column :properties, :rooms, :bedrooms
    add_column :properties, :area, :integer
  end
end
