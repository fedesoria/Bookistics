ReadingList::Application.routes.draw do
  resources :books, :except => [ :index, :destroy ]

  post 'books/lookup_books', :controller => :books, :action => :lookup_books, :as => :lookup_books

  match 'users/:id'   => 'users#show', :as => :profile, :via => :get

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure'            => 'sessions#failure'
  match '/signout'                 => 'sessions#destroy'

  root :to => 'application#index'
end
