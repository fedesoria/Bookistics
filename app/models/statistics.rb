class Statistics
  class << self
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
  end
end
