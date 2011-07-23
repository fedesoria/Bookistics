module BooksHelper
  NUM_OF_USERS_PER_BOOK = 5

  def get_book_users_links (book)
    book.
      users.take(NUM_OF_USERS_PER_BOOK).map { |u| link_to html_encode(u.name), user_path(u) }.
        join(', ').html_safe
  end
end
