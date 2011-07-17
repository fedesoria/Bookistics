class ReadingLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  STATUSES = { :read => "Read", :started => "Started", :unread => "Unread" }

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
end
