ReadingList::Application.routes.draw do
  resources :books

  post 'books/lookup_books', :controller => :books, :action => :lookup_books, :as => :lookup_books
  post 'books/:id', :controller => :books, :action => :create

  resources :users, :only => [ :index, :show ]

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure'            => 'sessions#failure'
  match '/signout'                 => 'sessions#destroy'

  root :to => 'application#index'
end
