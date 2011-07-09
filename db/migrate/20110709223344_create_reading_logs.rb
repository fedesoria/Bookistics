class CreateReadingLogs < ActiveRecord::Migration
  def self.up
    create_table :reading_logs do |t|
      t.references :user
      t.references :book

      t.datetime :start_date
      t.datetime :finish_date

      t.timestamps
    end
  end

  def self.down
    drop_table :reading_logs
  end
end
