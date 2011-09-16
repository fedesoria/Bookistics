class Statistics
  class << self
    DAYS_PER_YEAR   = 365.25
    MONTHS_PER_YEAR = 12.0
    DAYS_PER_MONTH  = DAYS_PER_YEAR / MONTHS_PER_YEAR

    def app_total_books
      Book.count(:id)
    end

    def app_total_users
      User.count(:id)
    end

    def user_total_books (user)
      ReadingLog
        .where('user_id = ?', user.id)
        .count(:id)
    end

    def user_reading_books (user)
      ReadingLog
        .where('user_id = ? and start_date is not null and finish_date is null', user.id)
        .count
    end

    def user_read_books (user)
      ReadingLog
        .where('user_id = ? and start_date is not null and finish_date is not null', user.id)
        .count
    end

    def user_read_pages (user)
      ReadingLog
        .joins(:book)
        .where(
          'reading_logs.user_id = ? and reading_logs.start_date is not null and reading_logs.finish_date is not null',
          user.id)
        .sum('books.pages')
    end

    def user_unread_books (user)
      ReadingLog
        .where('user_id = ? and start_date is null and finish_date is null', user.id)
        .count
    end

    def user_reading_since (user)
      ReadingLog
        .where('user_id = ? ', user.id)
        .minimum('start_date')
    end

    def user_reading_last (user)
      ReadingLog
        .where('user_id = ? ', user.id)
        .maximum('finish_date')
    end

    def user_average_books_per_month (user)
      days_reading = days_between_dates(user_reading_since(user), Date.today)
      read_books = user_read_books(user)

      return 0.0 if days_reading.to_i == 0 or read_books == 0

      average_per_month(read_books, days_reading)
    end

    def user_average_books_per_year (user)
      user_average_books_per_month(user) * MONTHS_PER_YEAR
    end

    def user_average_pages_per_month (user)
      days_reading = days_between_dates(user_reading_since(user), Date.today)
      read_pages = user_read_pages(user)

      return 0.0 if days_reading.to_i == 0 or read_pages == 0

      average_per_month(read_pages, days_reading)
    end

    def user_average_pages_per_year (user)
      user_average_pages_per_month(user) * MONTHS_PER_YEAR
    end

    def user_average_pages_per_day (user)
      user_average_pages_per_year(user) / DAYS_PER_YEAR
    end

    def user_average_days_per_book (user)
      books_per_month = user_average_books_per_month(user)

      return 0.0 if books_per_month == 0.0

      DAYS_PER_MONTH / books_per_month
    end

    private

    def days_between_dates (a, b)
      return nil if a.class != Date or b.class != Date
      (a - b).to_i.abs
    end

    def average_per_month (quantity, days)
      quantity.to_f / (days.to_f / DAYS_PER_MONTH)
    end
  end
end
