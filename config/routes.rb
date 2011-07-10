ReadingList::Application.routes.draw do
  get  'books/search'
  post 'books/search', :controller => :books, :action => :lookup_books

  get 'books/index'
  get 'books/create'

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure'            => 'sessions#failure'
  match '/signout'                 => 'sessions#destroy'

  root :to => 'books#search'
end
