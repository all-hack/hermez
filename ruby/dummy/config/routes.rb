Rails.application.routes.draw do
  get 'snail_mail/index'

  get 'cadet', to: 'cadet#new'  
  get 'cadet/create', to:'cadet#new'

  post 'cadet/create', to:'cadet#create'

  root to: 'snail_mail#index'
end
