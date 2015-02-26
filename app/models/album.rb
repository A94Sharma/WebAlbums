class Album < ActiveRecord::Base
    belongs_to :user
    has_many :pictures, dependent: :destroy
    validates :user_id, presence: true
    has_many :comments, :as => :commentable

end