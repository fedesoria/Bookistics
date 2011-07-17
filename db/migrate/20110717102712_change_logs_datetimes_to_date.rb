class ChangeLogsDatetimesToDate < ActiveRecord::Migration
  def self.up
    change_column(:reading_logs, :start_date, :date)
    change_column(:reading_logs, :finish_date, :date)
  end

  def self.down
    change_column(:reading_logs, :start_date, :datetime)
    change_column(:reading_logs, :finish_date, :datetime)
  end
end
