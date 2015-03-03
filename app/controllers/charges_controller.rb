class ChargesController < ApplicationController
  before_filter :current_user
	def new
    
  end

def create
   @cart =Cart.where(:id=>session[:cart_id]).first

  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :card  => params[:stripeToken]
  )


user = 'Rails Stripe customer id:' + current_user.id
 
  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @cart.total.to_i,
    :description => user,
    :currency    => 'usd'
  )

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to charges_path

  #means payment is receives with no errors
  
end
end
