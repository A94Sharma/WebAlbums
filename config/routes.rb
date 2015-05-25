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
    resources :comments
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
  
  resources :users do
    resources :malbums
  end
  resources :malbums do
    resources :songs
  end
  root 'welcome#index'
end
