class ReadingLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  default_scope :order => 'updated_at DESC'

  STATUSES = { :read => "Read", :started => "Started", :unread => "Unread" }

  validate :finish_date_cannot_be_less_than_start_date, :if => :dates_not_nil?

  def read?
    !start_date.nil? and !finish_date.nil?
  end

  def started?
    !start_date.nil?
  end

  def finished?
    !finish_date.nil?
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

  def dates_not_nil?
    !start_date.nil? && !finish_date.nil?
  end

  def finish_date_cannot_be_less_than_start_date
    errors.add(:finish_date, "cannot happen before start_date right?") unless
      finish_date >= start_date
  end
end
