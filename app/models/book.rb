class Book < ActiveRecord::Base
  has_many :reading_logs
  has_many :users, :through => :reading_logs
end
