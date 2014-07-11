Regisaurus::Application.routes.draw do

  root to: 'registrations#index'

  resources :registrations do
    get 'manage', on: :collection
    get 'waiver', on: :member
  end
  resources :matches do
    get 'latest', on: :collection
    get 'activate', on: :member
    get 'csv', on: :member
    get 'money', on: :member
  end

  resources :shooters do
    get 'search', on: :collection
  end

  resources :invoices do
    member do
      post 'reset_payments'
    end
  end

  match 'getcsv', to: 'matches#csv'

  devise_for :users
end
