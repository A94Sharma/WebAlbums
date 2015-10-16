class Song < ActiveRecord::Base
    acts_as_taggable_on :tags
	belongs_to :malbum
	validates :malbum_id, presence: true
	has_attached_file :song
    validates_attachment_presence :song
    validates_attachment_content_type :song, :content_type => [ 'audio/mp3','audio/mpeg']
    def owner_is(user)
        user_id==user.id ? true :false
    end
    def user
        User.find(user_id)
    end
end
