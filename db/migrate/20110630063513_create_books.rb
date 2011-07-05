class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string  :asin,        :null => false
      t.string  :title,       :null => false
      t.string  :authors,     :null => false
      t.integer :pages,       :null => false, :default => 0
      t.boolean :is_ebook,    :null => false, :default => false
      t.string  :image_url
      t.string  :icon_url
      t.string  :details_url, :null => false

      t.timestamps
    end

    add_index :books, :asin
  end

  def self.down
    remove_index :books, :asin
    drop_table   :books
  end
end
