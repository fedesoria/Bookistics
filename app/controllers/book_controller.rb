class BookController < ApplicationController

  SEARCH_RESULTS = 3

  # We map our supported sizes to their Amazon Image responses.
  BOOK_IMAGES = { :icon => "SmallImage", :image => "MediumImage" }

  ASIN::Configuration.configure :secret => 'Uf6KBM1SoFz41V5NNZFw3IoCzixQ73m8+tBtVjL2', :key => 'AKIAJHTAM7STAKSLLXRQ'

  def search
  end

  def lookup_books
    keywords = params[:keywords]

    unless keywords.nil?
      # Default ResponseGroup is small, we specify it anyways in case it ever changes.
      @results = ASIN.client.search(:Keywords      => keywords,
                                    :SearchIndex   => :Books,
                                    :ResponseGroup => :Small) || []
      unless @results.empty?
        @books = []
        @results.take(SEARCH_RESULTS).each do |result|
          image_info = ASIN.client.lookup(result.asin, :ResponseGroup => :Images)

          @books << result

          # Values in this hash are valid Amazon image responses.
          BOOK_IMAGES.values.each do |response|
            @books.last.raw[response] = image_info.raw[response]
          end
        end
      end
    end
  end
end
