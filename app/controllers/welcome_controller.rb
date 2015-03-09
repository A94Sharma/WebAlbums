class WelcomeController < ApplicationController
  def index
  	@pictures=Picture.all
  end
end
