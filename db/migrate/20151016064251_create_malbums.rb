class CreateMalbums < ActiveRecord::Migration
  def change
    create_table :malbums do |t|
    	t.string :title
    	t.text :description
    	t.references :user
    	t.timestamps null: false
    end
  end
end
