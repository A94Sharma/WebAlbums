class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
    	t.attachment :song
    	t.references :malbum
    	t.references :user
    	t.timestamps null: false
    end
  end
end
