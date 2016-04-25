class Idea < ActiveRecord::Base

  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  has_many :members, dependent: :destroy
  has_many :joined_users, through: :members, source: :user

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true


  def like_for(user)
    likes.find_by_user_id user if user
  end

  def join_for(user)
    members.find_by_user_id user if user
  end

end
