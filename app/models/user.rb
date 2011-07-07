class User < ActiveRecord::Base
  attr_protected :provider, :uid, :name

  class << self
    def create_with_auth(auth)
      create! do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']

        if auth['user_info']
          user.name = auth['user_info']['name'] if auth['user_info']['name']
        end
      end
    end
  end
end
