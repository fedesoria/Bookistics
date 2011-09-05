class Statistics
  class << self
    def app_total_books
      Book.count(:id)
    end

    def app_total_users
      User.count(:id)
    end
  end
end
