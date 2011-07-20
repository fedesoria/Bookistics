class BooksController < ApplicationController
  before_filter :require_user, :only => [ :new, :create, :edit, :show, :update, :lookup_books ]

  NUM_OF_BOOKS_ON_INDEX = 15

  def index
    @books = Book.order('created_at DESC').limit(NUM_OF_BOOKS_ON_INDEX)
  end

  def new
  end

  def lookup_books
    @books = AmazonBook.find(params[:keywords])
  end

  def create
    asin = params[:id]

    unless asin.nil?
      book = Book.find_by_asin(asin)

      unless book.nil?
        add_book_to_current_user(book) unless current_user.has_book? book.asin
      else
        amazon_book = AmazonBook.find_by_asin(asin)

        add_book_to_current_user(Book.new(amazon_book.attributes)) unless amazon_book.nil?
      end
    end
  end

  def show
    @book = Book.find_by_asin(params[:id]) || AmazonBook.find_by_asin(params[:id])

    unless @book.nil?
      if current_user.has_book?(@book.asin)
        @log = current_user.find_log(@book.asin)
        render :edit
      end
    else
      redirect_to_root_with_error("Book not found!")
    end
  end

  def edit
    asin = params[:id]

    if current_user.has_book?(asin)
      @book = Book.find_by_asin(asin)
      @log = current_user.find_log(asin)
    else
      redirect_to_root_with_error("Book not found!")
    end
  end

  def update
    if current_user.has_book?(params[:id])
      log = current_user.find_log(params[:id])

      log.start_date = params[:start_date]
      log.finish_date = params[:finish_date]

      log.save!
    end

    redirect_to edit_book_path(params[:id])
  end

  private

  def add_book_to_current_user (book)
    unless current_user.nil?
      current_user.books << book
      current_user.save!
    end
  end
end
