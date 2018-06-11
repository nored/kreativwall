Rails.application.routes.draw do
  get 'welcome/index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  constraints subdomain: 'api' do
    scope module: 'api' do
      namespace :v1 do
        resources :users
        resources :comments
        resources :likes
        resources :picture_posts
        resources :text_posts
        resources :video_posts
        resources :walls
      end
    end
  end
  resources :walls
  root to: redirect('/welcome/index')
  get ':url' => 'walls#show'
  post '/redirect' => 'walls#url'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
