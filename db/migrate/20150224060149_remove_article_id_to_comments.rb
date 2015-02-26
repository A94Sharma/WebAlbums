class RemoveArticleIdToComments < ActiveRecord::Migration
  def change
    remove_column :comments, :article_id, :integer
  end
end
