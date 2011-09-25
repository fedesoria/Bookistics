class UpdateBooksNoCoverImage < ActiveRecord::Migration
  def self.up
    execute "update Books set image_url = 'no_cover.gif', icon_url = 'no_cover.gif' where image_url like '%no-image-avail%'"
  end

  def self.down
  end
end
