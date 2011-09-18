class Book < ActiveRecord::Base
  has_many :reading_logs
  has_many :users, :through => :reading_logs

  self.per_page = 10

  def to_param
    asin
  end

  class << self
    def user_reading_books (user)
      Book
        .includes(:reading_logs)
        .where('reading_logs.user_id = ?
                and reading_logs.start_date is not null
                and reading_logs.finish_date is null', user.id)
        .order('reading_logs.updated_at DESC')
    end

    def user_read_books (user)
      Book
        .includes(:reading_logs)
        .where('reading_logs.user_id = ?
                and reading_logs.start_date is not null
                and reading_logs.finish_date is not null', user.id)
        .order('reading_logs.updated_at DESC')
    end

    def user_wants_to_read_books (user)
      Book
        .includes(:reading_logs)
        .where('reading_logs.user_id = ?
                and reading_logs.start_date is null
                and reading_logs.finish_date is null', user.id)
        .order('reading_logs.updated_at DESC')
    end
  end
end
