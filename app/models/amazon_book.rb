class AmazonBook
  # Numbers of results to return in find()
  SEARCH_RESULTS = 5

  EMPTY_IMAGE_URL = 'http://g-ecx.images-amazon.com/images/G/01/nav2/dp/no-image-avail-img-map._V192545771_AA300_.gif'

  ATTRIBUTES_LIST = [ :asin, :title, :authors, :pages, :image_url, :icon_url, :details_url, :editorial_review ]
  attr_accessor *ATTRIBUTES_LIST

  ASIN::Configuration.configure :secret => 'Uf6KBM1SoFz41V5NNZFw3IoCzixQ73m8+tBtVjL2', :key => 'AKIAJHTAM7STAKSLLXRQ', :logger => nil

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
    def find (keywords)
      # We first lookup the books with a Small response group, and then fetch the images
      # individually, it's faster than requesting a Medium response group which contains
      # images.
      books = []
      unless keywords.nil?
        # Default ResponseGroup is small, we specify it anyways in case it ever changes.
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
