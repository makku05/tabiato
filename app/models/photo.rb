class Photo < ApplicationRecord
  has_many :album_spot_photos, dependent: :destroy
  has_many :album_spots, through: :album_spot_photos
  belongs_to :user
  belongs_to :album
  has_one_attached :image
end
