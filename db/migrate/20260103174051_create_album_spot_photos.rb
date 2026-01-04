class CreateAlbumSpotPhotos < ActiveRecord::Migration[7.2]
  def change
    create_table :album_spot_photos do |t|
      t.references :album_spot, null: false, foreign_key: true
      t.references :photo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
