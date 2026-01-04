class Album < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :album_spots, dependent: :destroy
  
  # アルバムを通して、その中の写真全部を取得できるように
  has_many :photos, dependent: :destroy
  validates :title, presence: true
end
