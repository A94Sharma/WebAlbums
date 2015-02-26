class Comment < ActiveRecord::Base
    belongs_to :user # author of the comment
	belongs_to :commentable , :polymorphic => true
end
