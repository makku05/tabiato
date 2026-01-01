class Album < ApplicationRecord
  belongs_to :user
  has_many :album_spots, dependent: :destroy
  has_many :photos, through: :album_spots
end
