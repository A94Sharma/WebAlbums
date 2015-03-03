class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :roles, :string ,:default => "user"
  end
end
