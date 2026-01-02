class AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album, only: %i[show edit update destroy]

  def new
    @album = Album.new
  end

  def create
    @album = current_user.albums.build(album_params)

    if @album.save
      redirect_to albums_path, notice: "アルバムを作成しました！"
    else
      flash.now[:alert] = "アルバムの作成に失敗しました"
      render :new, status: :unprocessable_entity
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
    if @album.update(album_params)
      redirect_to album_path(@album), notice: "アルバムを更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @album.destroy!
    redirect_to albums_path, notice: "アルバムを削除しました", status: :see_other
  end

  private

  def album_params
    params.require(:album).permit(:title, :description, images: [])
  end

  def set_album
    @album = current_user.albums.find(params[:id])
  end
end
