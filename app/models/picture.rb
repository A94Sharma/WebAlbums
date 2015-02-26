class Picture < ActiveRecord::Base
    belongs_to :album

    has_many :comments, :as => :commentable
	acts_as_taggable_on :tags
	
	validates :album_id, :photo, presence: true
	has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>"}
    validates_attachment :photo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }   
end