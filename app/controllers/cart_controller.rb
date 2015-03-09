class CartController < ApplicationController
   before_filter :find_or_create_cart


	def create
	 @picture = Picture.where(:id => params[:picture_id]).first
     @cart.add(@picture, @picture.price)
     redirect_to :back

	end 

	def update
     @picture = Picture.where(:id => params[:picture_id]).first
     @cart.remove(@picture)
     redirect_to :back
	end

	def destroy
	@cart.clear
	redirect_to :back
	end

private #------------#------------
	def find_or_create_cart
 	cart_id = session[:cart_id]
    @cart = session[:cart_id] ? Cart.find(cart_id) : Cart.create
    session[:cart_id] = @cart.id
 	end


end
