Rails.application.routes.draw do
  get 'snail_mail/index'

  get 'cadet', to: 'cadet#new'  
  get 'cadet/create', to:'cadet#new'

  post 'cadet/create', to:'cadet#create'
  
  post 'snail_mail/select_cadet', to:'snail_mail#select_cadet'
  post 'snail_mail/deselect_cadet', to:'snail_mail#deselect_cadet'
  get 'snail_mail/clear_list', to:'snail_mail#clear_list'

  get 'snail_mail/send', to: 'snail_mail#send_email'

  post 'cadet/import', to: 'cadet#import_cadets_fremont'

  root to: 'snail_mail#index'
end
