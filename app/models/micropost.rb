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
  scope :feed, lambda {|following_ids, id|
    where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  }

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return if picture.size < Settings.image.maxsize.megabytes
    errors.add :picture, t("microposts.maxsize")
  end
end
