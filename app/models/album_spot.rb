class AlbumSpot < ApplicationRecord
  belongs_to :album
  has_many :album_spot_photos, dependent: :destroy
  has_many :photos, through: :album_spot_photos
end
