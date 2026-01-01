class Photo < ApplicationRecord
  belongs_to :album_spot
  # ※ここに後で has_one_attached :image を追記します（今日はまだOK）
end
