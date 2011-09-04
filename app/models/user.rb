class User < ActiveRecord::Base
  has_many :authentications
  has_many :reading_logs
  has_many :books, :through => :reading_logs

  attr_protected :name, :email

  def to_param
    User.escape(name)
  end

  def has_book? (asin)
    self.books.any? { |user_book| user_book.asin == asin }
  end

  def find_log (asin)
    self.reading_logs.select { |log| log.book.asin == asin }.first if self.has_book?(asin)
  end

  class << self
    def create_from_auth (auth)
      user = User.new

      if auth['user_info']
        user.name       = auth['user_info']['name'] if auth['user_info']['name']
        user.avatar_url = auth['user_info']['image'] if auth['user_info']['image']
        user.nickname   = auth['user_info']['nickname'] if auth['user_info']['nickname']
      end

      if auth['extra']['user_hash']
          user.name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name']
      end

      user.authentications.build(:provider => auth['provider'], :uid => auth['uid'])
      user.save!
      user
    end

    def escape(value)
      value.gsub(/ /, "_")
    end

    def unescape(value)
      value.gsub(/_/, " ")
    end
  end
end
