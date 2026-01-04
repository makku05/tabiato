class AddStatusToAlbums < ActiveRecord::Migration[7.2]
  def change
    add_column :albums, :status, :integer, default: 0, null: false
  end
end
