class SongsController < ApplicationController
  before_action :set_album
  def new
  end
  
  def create 
    @song=@malbum.songs.new(song_params)
    @song.user_id=current_user.id
    if @song.save
      redirect_to malbum_path(@malbum)
    else
      render :new
    end
  end

  def destroy
    @song=@malbum.songs.find(params[:id])
    @song.destroy
    redirect_to malbum_path(@malbum)
  end

  private
  def song_params
    params.require(:song).permit(:song,:tag_list)
  end
  def set_album
    @malbum = Malbum.find(params[:malbum_id])
  end
end
