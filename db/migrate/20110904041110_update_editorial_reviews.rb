class UpdateEditorialReviews < ActiveRecord::Migration
  class Book < ActiveRecord::Base
  end

  def self.up
    Book.all.each do |book|
      amazon = AmazonBook.find_by_asin book.asin
      book.update_attributes! :editorial_review => amazon.editorial_review
    end
  end

  def self.down
  end
end
