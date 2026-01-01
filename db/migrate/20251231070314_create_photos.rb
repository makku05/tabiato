class CreatePhotos < ActiveRecord::Migration[7.2]
  def change
    create_table :photos do |t|
      t.references :album_spot, null: false, foreign_key: true
      t.datetime :taken_at
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
