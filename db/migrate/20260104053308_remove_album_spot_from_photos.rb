class RemoveAlbumSpotFromPhotos < ActiveRecord::Migration[7.2]
  def change
    remove_reference :photos, :album_spot, null: false, foreign_key: true
  end
end
