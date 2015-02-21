Rails.application.routes.draw do
  devise_for :users
  resources :users do
    resources :albums 
  end


  resources :albums do
    resources :pictures
  end
	resources :articles do
	  resources :comments
	end
  
  root 'welcome#index'
end
