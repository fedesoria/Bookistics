class BooksController < ApplicationController
  before_filter :require_user, :only => [ :create ]

  def search
  end

  def lookup_books
    @books = AmazonBook.find(params[:keywords])
  end

  def create
    asin = params[:asin]

    if !asin.nil?
      @book = Book.find_by_asin(asin)

      if !@book.nil?
        add_book_to_current_user(@book) if
          !current_user.books.any? { |book| book.asin == @book.asin }

        redirect_to root_url
      else
        amazon_book = AmazonBook.find_by_asin(asin)

        if !amazon_book.nil?
          add_book_to_current_user(Book.new(amazon_book.attributes))

          redirect_to root_url
        else
          redirect_to_root_with_error("ASIN doesn't exist!")
        end
      end
    else
      redirect_to_root_with_error("Invalid ASIN given.")
    end
  end

  private

  def add_book_to_current_user (book)
    unless current_user.nil?
      current_user.books << book
      current_user.save!
    end
  end
end
