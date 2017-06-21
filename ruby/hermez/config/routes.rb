Rails.application.routes.draw do
  get 'snail_mail/index'

  get 'cadet', to: 'cadet#new'  
  get 'cadet/create', to:'cadet#new'

  post 'cadet/create', to:'cadet#create'
  
  post 'snail_mail/select_cadet', to:'snail_mail#select_cadet'
  post 'snail_mail/deselect_cadet', to:'snail_mail#deselect_cadet'
  post 'snail_mail/clear_list', to:'snail_mail#clear_list'

  root to: 'snail_mail#index'
end
