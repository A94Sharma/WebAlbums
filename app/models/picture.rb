class Picture < ActiveRecord::Base
    belongs_to :album

    has_many :comments, :as => :commentable
	acts_as_taggable_on :tags
	
	validates :album_id, :photo, presence: true
	has_attached_file :photo, :styles => { :icon => "16x16>",:medium => "300x300>", :thumb => "100x100>"}
    validates_attachment :photo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }   



    def user 
     User.find(user_id)
    end

    
end