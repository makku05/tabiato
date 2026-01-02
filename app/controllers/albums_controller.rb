class AlbumsController < ApplicationController
  # ログインしていないと見れないように
  before_action :authenticate_user!

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
    @album = Album.find(params[:id])
  end

  private

  def album_params
    params.require(:album).permit(:title, :description)
  end
end
