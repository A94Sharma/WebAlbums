class MalbumsController < ApplicationController
  before_filter :current_user
  def index
    @malbum = Malbum.all
  end

  def show
    @malbum = current_user.malbums.find(params[:id])
    if params[:tag].present? 
      @songs = @malbum.songs.tagged_with(params[:tag])
    else
      @songs=@malbum.songs.all
    end
  end

  def new
  	@malbum = current_user.malbums.new
  end

  def create
    @malbum = current_user.malbums.new(malbum_params)
    if @malbum.save
      redirect_to @malbum
    else
      render 'new'
    end
  end

  def edit
    @malbum = current_user.malbums.find(params[:id])
  end

  def destroy
    @malbum = current_user.malbums.find(params[:id])
    @malbum.destroy
    redirect_to malbums_path
  end

  def update
     @malbum = current_user.malbums.find(params[:id])
    if @malbum.update(malbum_params)
      redirect_to @malbum
    else
      render 'edit'
    end
  end

  private
    def malbum_params
      params.require(:malbum).permit(:title, :description, :id)
    end
end
