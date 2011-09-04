class AddEditorialReview < ActiveRecord::Migration
  def self.up
    add_column :books, :editorial_review, :text
  end

  def self.down
    remove_column :books, :editorial_review
  end
end
