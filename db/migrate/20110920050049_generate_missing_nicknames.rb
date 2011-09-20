class GenerateMissingNicknames < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def self.up
    User.all.each do |user|
      user.update_attributes! :nickname => "user#{user.id}" unless user.nickname
    end
  end

  def self.down
  end
end
