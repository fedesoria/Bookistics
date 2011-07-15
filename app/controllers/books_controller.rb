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
        if !current_user.books.any? { |book| book.asin == @book.asin }
          current_user.books << @book
          current_user.save!
        end

        redirect_to root_url
      else
        amazon_book = AmazonBook.find_by_asin(asin)

        if !amazon_book.nil?
          @book = Book.new(amazon_book.attributes)

          current_user.books << @book
          current_user.save!

          redirect_to root_url
        else
          flash[:notice] = "ASIN doesn't exist!"
          redirect_to root_url
        end
      end
    else
      flash[:notice] = "Invalid ASIN given."
      redirect_to root_url
    end
  end

  def index
    @books = current_user.books
  end
end
