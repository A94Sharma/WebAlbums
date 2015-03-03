module AlbumsHelper
	include ActsAsTaggableOn::TagsHelper

	  def self.user
      User.find(user_id)
      end

end
