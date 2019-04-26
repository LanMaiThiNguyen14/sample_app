class Micropost < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.Post.content_size}
  validate  :picture_size

  scope :micropost_desc, ->{order created_at: :desc}
  scope :feed, (lambda do |user|
    where user_id: user.id
  end)

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > Settings.Post.size_image.megabytes
    errors.add(:picture, t("microposts.controller.size_image_content"))
  end
end
