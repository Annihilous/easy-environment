Rails.application.routes.draw do
  get 'pages/index'
  resources :invoices
end
