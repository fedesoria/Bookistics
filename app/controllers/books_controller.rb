class BooksController < ApplicationController
  before_filter :require_user, :only => [ :new, :create, :edit, :show, :update, :lookup_books ]
  before_filter :current_user_has_book? => [ :edit, :update ]

  def index
    @books = Book
               .includes(:users)
               .paginate(:page => params[:page])
               .order('books.created_at DESC')
  end

  def new
  end

  def lookup_books
    @books = AmazonBook.find(params[:keywords])
  end

  def create
    asin = params[:id]

    unless asin.nil?
      @book = Book.find_by_asin(asin)

      unless @book.nil?
        add_book_to_current_user(@book) unless current_user.has_book? @book.asin
      else
        amazon_book = AmazonBook.find_by_asin(asin)

        add_book_to_current_user(@book = Book.new(amazon_book.attributes)) unless amazon_book.nil?
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

    @book = Book.find_by_asin(asin)
    @log = current_user.find_log(asin)

    if @book.nil? or @log.nil?
      redirect_to_root_with_error('Book was not found!')
    end
  end

  def update
    start_date = Chronic.parse(params[:start_date])
    finish_date = Chronic.parse(params[:finish_date])

    unless (start_date.nil? and !params[:start_date].empty?) or
        (finish_date.nil? and !params[:finish_date].empty?)
      log = current_user.find_log(params[:id])

      log.start_date = (params[:start_date].empty?) ? nil : start_date.to_date
      log.finish_date = (params[:finish_date].empty?) ? nil : finish_date.to_date

      if log.valid?
        log.save!
        flash[:notice] = 'Updated successfully!'
      else
        flash[:error] = log.errors.full_messages.first
      end
    else
      flash[:error] = 'Date was not recognized!'
    end
  end

  def destroy
    @asin = params[:id]
    log = current_user.find_log(params[:id])
    log.destroy
    flash[:notice] = "Book removed from the list!"
  end

  private

  def current_user_has_book?
    if current_user.nil? or !current_user.has_book?(params[:id])
      redirect_to_root_with_error("Sorry but you don't seem to have that book!")
    end
  end

  def add_book_to_current_user (book)
    unless current_user.nil?
      current_user.books << book
      current_user.save!
    end
  end
end
