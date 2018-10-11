class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.constant.content_max_length}
  default_scope -> {order created_at: :desc}
end
