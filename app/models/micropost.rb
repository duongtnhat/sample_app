class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.constant.content_max_length}
  validate  :picture_size
  mount_uploader :picture, PictureUploader
  default_scope -> {order created_at: :desc}

  private

  def picture_size
    if picture.size > Settings.constant.picture_max_size.megabytes
      errors.add :picture, t("upload.img_max_size")
    end
  end
end
