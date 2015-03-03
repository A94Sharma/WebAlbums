class AlbumsController < ApplicationController
  before_filter :current_user
  
  def index
    @album = Album.all
  end
  
  def show
    @album = Album.find(params[:id])
    if params[:tag].present? 
      @pictures = @album.pictures.tagged_with(params[:tag])
    else
      @pictures=@album.pictures.all
    end
  end

  def new
    @album = current_user.albums.new
  end
  
  def create
    @album = current_user.albums.new(album_params)
    
    if @album.save
      redirect_to @album
    else
      render 'new'
    end
  end

  def edit
    @album = current_user.albums.find(params[:id])
  end

  def destroy
    @album = current_user.albums.find(params[:id])
    @album.destroy
    redirect_to albums_path
  end

  def update
     @album = current_user.albums.find(params[:id])
    if @album.update(album_params)
      redirect_to @album
    else
      render 'edit'
    end
  end

  private
    def album_params
      params.require(:album).permit(:title, :description, :id)
    end

end
