Rails.application.routes.draw do
  devise_for :users
  #charges for Stripe payments
  resources :charges
  
    resources :cart do
    put 'clear'
    end
    
  resources :users do
    resources :albums 
  end


  resources :albums do
    resources :pictures do 
      resources :comments
    end
  end

  resources :pictures do 
      resources :comments
    end
	resources :articles do
	  resources :comments
	end
  
  
  root 'welcome#index'
end
