ReadingList::Application.routes.draw do
  get "book/search"
  post "book/search", :controller => :book, :action => :lookup_books
end
