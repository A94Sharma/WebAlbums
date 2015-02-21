class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.text :description
      t.references :user
      t.timestamps null: false
    end
    #add_index :albums, :user, :presence => true
  end
end
