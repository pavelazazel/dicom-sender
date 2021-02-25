Rails.application.routes.draw do
  root 'queue#index'

  get 'queue/send_dcm'
  get 'queue/erase_dir'
end
