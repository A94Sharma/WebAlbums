class AddPriceAndUnitToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :price, :integer,:default => 0
    add_column :pictures, :unit, :string,:default => 'usd'
  end
end
