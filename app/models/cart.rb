class Cart < ActiveRecord::Base
	acts_as_shopping_cart_using :cart_item


	def taxes
    0.0
  end
end
