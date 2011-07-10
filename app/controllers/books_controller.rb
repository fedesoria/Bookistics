class BooksController < ApplicationController
  before_filter :require_user, :only => [ :create ]

  SEARCH_RESULTS = 3

  # We map our supported sizes to their Amazon Image responses.
  BOOK_IMAGES = { :icon => "SmallImage", :image => "MediumImage" }

  ASIN::Configuration.configure :secret => 'Uf6KBM1SoFz41V5NNZFw3IoCzixQ73m8+tBtVjL2', :key => 'AKIAJHTAM7STAKSLLXRQ', :logger => nil

  def search
  end

  def lookup_books
    keywords = params[:keywords]

    unless keywords.nil?
      # Default ResponseGroup is small, we specify it anyways in case it ever changes.
      @results = ASIN::Client.instance.search(:Keywords      => keywords,
                                              :SearchIndex   => :Books,
                                              :ResponseGroup => :Small) || []
      unless @results.empty?
        @books = []
        @results.take(SEARCH_RESULTS).each do |result|
          image_info = ASIN::Client.instance.lookup(result.asin, :ResponseGroup => :Images)

          @books << result

          # Values in this hash are valid Amazon image responses.
          BOOK_IMAGES.values.each do |response|
            @books.last.raw[response] = image_info.raw[response]
          end
        end
      end
    end
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
        @lookup = ASIN::Client.instance.lookup(asin, :ResponseGroup => :Medium)

        if !@lookup.asin.nil?
          @book = Book.new(:asin => @lookup.asin,
                           :title => @lookup.title,
                           :authors => @lookup.raw.ItemAttributes.Author.respond_to?(:join) ?
                             @lookup.raw.ItemAttributes.Author.join(', ') :
                             @lookup.raw.ItemAttributes.Author,
                           :pages => @lookup.raw.ItemAttributes.NumberOfPages,
                           :image_url => @lookup.raw[BOOK_IMAGES[:image]].URL,
                           :icon_url => @lookup.raw[BOOK_IMAGES[:icon]].URL,
                           :details_url => @lookup.details_url)
          @book.save!

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
