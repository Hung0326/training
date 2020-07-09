class Micropost < ActiveRecord::Base  
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, length: { maximum: 1000 }, presence: true
  validates :user_id, presence: true 
  
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
