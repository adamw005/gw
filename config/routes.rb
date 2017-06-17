Rails.application.routes.draw do
	devise_for :users, :controllers => {:registrations => "registrations"}
  get 'pages/landing'
	get 'pages/landing2'
  get 'projects/show/:id', to: 'projects#show', as: 'projects'
  get 'projects/index'
  get 'projects/new'
	post 'projects/create'
	post 'posts/create'
	post 'comments/create'
	post 'subscriptions/create'
	post 'stripe_infos/create'
	post 'stripe_infos/add_bank_account'
	post 'stripe_infos/remove_bank_account', to: 'stripe_infos#remove_bank_account', as: 'stripe_infos_remove_bank_account'
	post 'stripe_infos/default_bank_account', to: 'stripe_infos#default_bank_account', as: 'stripe_infos_default_bank_account'
	post 'stripe_infos/create_payout', to: 'stripe_infos#create_payout', as: 'stripe_infos_create_payout'
	post 'stripe_infos/submit_fields_needed', to: 'stripe_infos#submit_fields_needed', as: 'stripe_infos_submit_fields_needed'
	post 'stripe/webhooks', to: 'stripe_infos#stripe_webhooks', as: 'stripe_wehbooks'
	post 'releases/create'
	delete 'subscriptions/destroy/:id', to: 'subscriptions#destroy', as: 'subscriptions_destroy'
	get 'projects/dashboard/:id', to: 'projects#dashboard', as: 'dashboard'
	root to: 'pages#landing2'
	get '/:slug', to: 'projects#show', as: 'projects_slug'
	get 'settings/withdraw/:id', to: 'settings#withdraw', as: 'withdraw'
	get 'users/show:id', to: 'users#show', as: 'user_show'

	resources :charges

end
