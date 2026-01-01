class AlbumSpot < ApplicationRecord
  belongs_to :album
  has_many :photos, dependent: :destroy
end
