class FixBooksEditorialReviews < ActiveRecord::Migration
  class Book < ActiveRecord::Base
  end

  def self.up
    Book.all.each do |book|
      unless book.editorial_review.nil?
        book.update_attributes!(:editorial_review => book.editorial_review.gsub(/(<[^>]*>)|\n|\t/, ''))
      end
    end
  end

  def self.down
  end
end
