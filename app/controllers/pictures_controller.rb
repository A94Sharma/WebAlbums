class PicturesController < ApplicationController
    before_filter :current_user
    def new
    @album = current_user.albums.find(params[:album_id])
    end
  
    def create 
    @album = current_user.albums.find(params[:album_id])
    @picture=@album.pictures.create(picture_params)
    @picture.update_attribute(:user_id ,current_user.id)
    if @picture.save
      redirect_to album_path(@album)
    else
      render :new
    end
    
    end
  def show
    @album = Album.find(params[:album_id])
    @picture=@album.pictures.find(params[:id])
  end
  def destroy
    @album = Album.find(params[:album_id])
    @picture=@album.pictures.find(params[:id])
    @picture.destroy
    redirect_to album_path(@album)
  end
  
  def transfer_photo
    #transfer the cart photos
   redirect_to album_path
  end
  
  private
  def picture_params
    params.require(:picture).permit(:photo ,  :tag_list , :price ,:unit)
  end
  
   def start_transfer
   @cart = session[:cart_id]
   
   @cart.items.each do |item|
 
   @picture = current_user.Picture.new(item) 
   @picture.update_attributes(:user_id current_user.id , 
    :album_id current_user.Album.find(1).first.id)
   if @picture.save
     @cart.clear
   else
    #failed
    end

   end

  
   
    
  end
end
