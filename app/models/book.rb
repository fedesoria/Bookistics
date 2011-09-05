class Book < ActiveRecord::Base
  has_many :reading_logs
  has_many :users, :through => :reading_logs

  self.per_page = 10

  def to_param
    asin
  end
end
