class User < ActiveRecord::Base
  has_many :authentications
  has_many :reading_logs
  has_many :books, :through => :reading_logs

  attr_protected :name, :email

  class << self
    def create_from_auth (auth)
      user = User.new

      if auth['user_info']
        user.name = auth['user_info']['name'] if auth['user_info']['name']
      end

      if auth['extra']['user_hash']
          user.name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name']
      end

      user.authentications.build(:provider => auth['provider'], :uid => auth['uid'])
      user.save!
      user
    end
  end
end
