class PicturesController < ApplicationController
  #before_action :set_album #, :except => [:new]
    def new
    @album = Album.find(params[:album_id])
    end
  
    def create 
    @album = Album.find(params[:album_id])
    @picture=@album.pictures.create(picture_params)
    if @picture.save
      redirect_to album_path(@album)
    else
      render :new
    end
    
    end
  
  def destroy
    @album = Album.find(params[:album_id])
    @picture=@album.pictures.find(params[:id])
    @picture.destroy
    redirect_to album_path(@album)
  end
  
  
  private
  def picture_params
    params.require(:picture).permit(:photo ,  :tag_list )
  end

end
