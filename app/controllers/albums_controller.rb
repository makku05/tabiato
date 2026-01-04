class AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album, only: %i[show edit update destroy]

  def new
    @album = Album.new
  end

  def create
    # データから画像だけを取り除く
    @album = current_user.albums.build(album_params.except(:images))

    if @album.save
      # 画像が送られてきてるのかのチェック
      if params[:album][:images]
        ActiveRecord::Base.transaction do
          # スポット数を数える変数
          spotn = 0
          # rejectで空のデータを除外
          params[:album][:images].reject(&:blank?).each do |image|
            exif_data = ImageAnalyzer.call(image)
            spotn = spotn + 1

            # 将来的に写真複数枚でグループ分け予定
            spot = @album.album_spots.create(
              spot_name: "スポット" + spotn.to_s,
              latitude: exif_data&.dig(:latitude),
              longitude: exif_data&.dig(:longitude)
            )

            photo = Photo.new(
              taken_at: exif_data&.dig(:taken_at),
              latitude: exif_data&.dig(:latitude),
              longitude: exif_data&.dig(:longitude),
              user: current_user,
              album: @album
            )

            photo.image.attach(image)
            photo.save!
            # 中間テーブルへの保存
            spot.photos << photo
          end
        end
      redirect_to albums_path, notice: "アルバムを作成しました！"
      else
        flash.now[:alert] = "アルバムの作成に失敗しました"
        render :new, status: :unprocessable_entity
      end
    end
  end

  def index
    # 最新順に並べる
    @albums = Album.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    # 画像以外のデータを先に更新
    if @album.update(album_params.except(:images))

      # 新しい画像が追加されているかチェック
      if params[:album][:images]

        ActiveRecord::Base.transaction do
          spotn = @album.album_spots.count

          params[:album][:images].reject(&:blank?).each do |image|
            exif_data = ImageAnalyzer.call(image)

            spotn = spotn + 1

            spot = @album.album_spots.create!(
              spot_name: "スポット" + spotn.to_s,
              latitude: exif_data&.dig(:latitude),
              longitude: exif_data&.dig(:longitude)
            )

            photo = Photo.new(
              taken_at: exif_data&.dig(:taken_at),
              latitude: exif_data&.dig(:latitude),
              longitude: exif_data&.dig(:longitude),
              user: current_user,
              album: @album
            )

            photo.image.attach(image)
            photo.save!

            spot.photos << photo
          end
        end
      end

      redirect_to album_path(@album), notice: "アルバムを更新しました！"
    else
      flash.now[:alert] = "アルバムの更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end

  rescue => e
    flash.now[:alert] = "更新に失敗しました: #{e.message}"
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @album.destroy!
    redirect_to albums_path, notice: "アルバムを削除しました", status: :see_other
  end

  private

  def album_params
    # 写真を複数枚受け取れるように
    params.require(:album).permit(:title, :description, images: [])
  end

  def set_album
    @album = current_user.albums.find(params[:id])
  end
end
