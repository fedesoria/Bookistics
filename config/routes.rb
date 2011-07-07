ReadingList::Application.routes.draw do
  get  'book/search'
  post 'book/search', :controller => :book, :action => :lookup_books

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure'            => 'sessions#failure'
  match '/signout'                 => 'sessions#destroy'

  root :to => 'book#search'
end
