class Malbum < ActiveRecord::Base
	belongs_to :user
    has_many :songs, dependent: :destroy
    validates :user_id, :title, presence: true
end
