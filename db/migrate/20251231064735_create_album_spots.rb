class CreateAlbumSpots < ActiveRecord::Migration[7.2]
  def change
    create_table :album_spots do |t|
      t.references :album, null: false, foreign_key: true
      t.string :spot_name
      t.text :description
      t.datetime :arrival_time
      t.datetime :departure_time
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
