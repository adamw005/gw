Rails.application.routes.draw do
	devise_for :users, :controllers => {:registrations => "my_devise/registrations"}
  get 'pages/landing'
  get 'projects/show/:id', to: 'projects#show', as: 'projects'
  get 'projects/index'
  get 'projects/new'
	post 'projects/create'
	post 'posts/create'
	post 'comments/create'
	root to: 'pages#landing'

	resources :charges

end
