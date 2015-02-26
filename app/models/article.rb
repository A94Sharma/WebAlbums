class Article < ActiveRecord::Base
	belongs_to :user
    has_many :comments, :as => :commentable
    validates :title, presence: true #,length: { minimum:commentable_id 3 }
  
end
