class Album < ActiveRecord::Base
    belongs_to :user
    has_many :pictures, dependent: :destroy
    validates :user_id, presence: true

end
