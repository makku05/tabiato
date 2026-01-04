class AddUserAndAlbumToPhotos < ActiveRecord::Migration[7.2]
  def change
    add_reference :photos, :user, null: false, foreign_key: true
    add_reference :photos, :album, null: false, foreign_key: true
  end
end
