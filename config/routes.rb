Rails.application.routes.draw do
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
