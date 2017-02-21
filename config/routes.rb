Rails.application.routes.draw do
  devise_for :users
  get 'pages/landing'
  get 'projects/show/:id', to: 'projects#show', as: 'projects'
  get 'projects/index'
  get 'projects/new'
	post 'projects/create'
	post 'posts/create'
	post 'comments/create'
	root to: 'pages#landing'

end
