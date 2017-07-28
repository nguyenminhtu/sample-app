class Micropost < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true,
    length: {
      maximum: Settings.content.maximum,
      minimum: Settings.content.minimum
    }
  validate :picture_size

  scope :most_recent, ->{order created_at: :desc}

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    if picture.size > Settings.image.maxsize.megabytes
      errors.add :picture, t("microposts.maxsize")
    end
  end
end
