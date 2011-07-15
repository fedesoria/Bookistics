class AmazonBook
  # Numbers of results to return in find()
  SEARCH_RESULTS = 3

  ATTRIBUTES_LIST = [ :asin, :title, :authors, :pages, :image_url, :icon_url, :details_url ]
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
    result = {}
    ATTRIBUTES_LIST.each { |attrb| result[attrb.to_s] = send(attrb) }
    result
  end

  class << self
    def find (keywords)
      # We first lookup the books with a Small response group, and then fetch the images
      # individually, it's faster than requesting a Medium response group which contains
      # images.
      unless keywords.nil?
        # Default ResponseGroup is small, we specify it anyways in case it ever changes.
        results = ASIN::Client.instance.search(:Keywords      => keywords,
                                                :SearchIndex   => :Books,
                                                :ResponseGroup => :Small) || []
        unless results.empty?
          books = []
          results.take(SEARCH_RESULTS).each do |result|
            image_info = ASIN::Client.instance.lookup(result.asin, :ResponseGroup => :Images)

            books << AmazonBook.new(:asin => result.asin,
                      :title => result.title,
                      :authors => result.raw.ItemAttributes.Author.respond_to?(:join) ?
                        result.raw.ItemAttributes.Author.join(', ') :
                        result.raw.ItemAttributes.Author,
                      :pages => result.raw.ItemAttributes.NumberOfPages,
                      :image_url => image_info.raw["MediumImage"].URL,
                      :icon_url => image_info.raw["SmallImage"].URL,
                      :details_url => result.details_url)
          end
          return books
        end
      end
      []      # If we got to this point we found nothing, return empty array.
    end

    def find_by_asin (asin)
      lookup = ASIN::Client.instance.lookup(asin, :ResponseGroup => :Medium)

      if !lookup.asin.nil?
        AmazonBook.new(:asin => lookup.asin,
                       :title => lookup.title,
                       :authors => lookup.raw.ItemAttributes.Author.respond_to?(:join) ?
                         lookup.raw.ItemAttributes.Author.join(', ') :
                         lookup.raw.ItemAttributes.Author,
                       :pages => lookup.raw.ItemAttributes.NumberOfPages,
                       :image_url => lookup.raw["MediumImage"].URL,
                       :icon_url => lookup.raw["SmallImage"].URL,
                       :details_url => lookup.details_url)
      else
        nil
      end
    end
  end
end
