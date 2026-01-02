class Album < ApplicationRecord
  belongs_to :user
  has_many :album_spots, dependent: :destroy
  has_many :photos, through: :album_spots
  has_many_attached :images

  validates :title, presence: true
end
