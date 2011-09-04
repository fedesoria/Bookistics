class AddAvatarAndNickname < ActiveRecord::Migration
  def self.up
    add_column :users, :nickname, :string
    add_column :users, :avatar_url, :string
  end

  def self.down
    remove_column :users, :avatar_url
    remove_column :users, :nickname
  end
end
