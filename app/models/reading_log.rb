class ReadingLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  default_scope :order => 'updated_at DESC'

  STATUSES = { :read => "Read", :started => "Started", :unread => "Unread" }

  validate :finish_date_cannot_be_less_than_start_date, :if => :dates_not_nil?

  def started?
    !start_date.nil?
  end

  def read?
    dates_not_nil?
  end

  def status
    if read?
      :read
    elsif started?
      :started
    else
      :unread
    end
  end

  def status_string
    STATUSES[status]
  end

  def reading_for
    return 0 unless started?
    return days_between_dates(start_date, Date.today) unless read?
    days_between_dates(start_date, finish_date)
  end

  def read_in_days
    return 0 unless read?
    days_between_dates(start_date, finish_date)
  end

  private

  def days_between_dates (first, second)
    (second - first).abs.to_i
  end
end

class ReadingLog
  def dates_not_nil?
    !start_date.nil? && !finish_date.nil?
  end

  def finish_date_cannot_be_less_than_start_date
    errors.add(:finish_date, "cannot happen before start_date right?") unless
      finish_date >= start_date
  end
end
