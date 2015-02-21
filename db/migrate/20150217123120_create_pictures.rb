class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.attachment :photo
      t.references :album
      t.references :user
      t.timestamps null: false
    end
    add_index :pictures, :album, presence: true
  end
end
