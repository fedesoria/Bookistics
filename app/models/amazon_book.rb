class AmazonBook
  # Numbers of results to return in find()
  SEARCH_RESULTS = 5

  EMPTY_IMAGE_URL = 'no_cover.gif'

  ATTRIBUTES_LIST = [ :asin, :title, :authors, :pages, :image_url, :icon_url, :details_url, :editorial_review ]
  attr_accessor *ATTRIBUTES_LIST

  ASIN::Configuration.configure :secret => ENV['AMAZON_SECRET'], :key => ENV['AMAZON_KEY'], :logger => nil

  def initialize (attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if ATTRIBUTES_LIST.include? name.to_sym
    end
  end

  def persisted?
    false
  end

  def attributes
    Hash[*ATTRIBUTES_LIST.collect { |attrb| [attrb.to_s, send(attrb)] }.flatten]
  end

  class << self
    def find_debug (asin)
      lookup = ASIN::Client.instance.lookup(asin, :ResponseGroup => :Large)
    end

    def find (keywords)
      books = []
      unless keywords.nil?
        results = ASIN::Client.instance.search(:Keywords      => keywords,
                                               :SearchIndex   => :Books,
                                               :ResponseGroup => :Medium) || []
        unless results.empty?
          results.take(SEARCH_RESULTS).each do |result|

            image_url = icon_url = EMPTY_IMAGE_URL

            if result.raw.key? :MediumImage
              image_url = result.raw.MediumImage.URL
            end

            if result.raw.key? :SmallImage
              icon_url = result.raw.SmallImage.URL
            end

            editorial_review = nil

            if result.raw.key? :EditorialReviews
              editorial_review = result.raw.EditorialReviews.EditorialReview.class == Array ?
                result.raw.EditorialReviews.EditorialReview.first.Content :
                result.raw.EditorialReviews.EditorialReview.Content
              editorial_review.gsub!(/(<[^>]*>)|\n|\t/, '')
            end

            books << AmazonBook.new(:asin => result.asin,
                      :title => result.title,
                      :authors => result.raw.ItemAttributes.Author.respond_to?(:join) ?
                        result.raw.ItemAttributes.Author.join(', ') :
                        result.raw.ItemAttributes.Author,
                      :pages => result.raw.ItemAttributes.NumberOfPages,
                      :image_url => image_url,
                      :icon_url => icon_url,
                      :details_url => result.details_url,
                      :editorial_review => editorial_review)
          end
        end
      end
      books
    end

    def find_by_asin (asin)
      lookup = ASIN::Client.instance.lookup(asin, :ResponseGroup => :Medium)

      if !lookup.empty? and !lookup.first.asin.nil?
        item = lookup.first

        image_url = icon_url = EMPTY_IMAGE_URL

        if item.raw.key? :MediumImage
          image_url = item.raw.MediumImage.URL
        end

        if item.raw.key? :SmallImage
          icon_url = item.raw.SmallImage.URL
        end

        editorial_review = nil

        if item.raw.key? :EditorialReviews
          editorial_review = item.raw.EditorialReviews.EditorialReview.class == Array ?
            item.raw.EditorialReviews.EditorialReview.first.Content :
            item.raw.EditorialReviews.EditorialReview.Content
          editorial_review.gsub!(/(<[^>]*>)|\n|\t/, '')
        end

        AmazonBook.new(:asin => item.asin,
                       :title => item.title,
                       :authors => item.raw.ItemAttributes.Author.respond_to?(:join) ?
                         item.raw.ItemAttributes.Author.join(', ') :
                         item.raw.ItemAttributes.Author,
                       :pages => item.raw.ItemAttributes.NumberOfPages,
                       :image_url => image_url,
                       :icon_url => icon_url,
                       :details_url => item.details_url,
                       :editorial_review => editorial_review)
      else
        nil
      end
    end
  end
end
