class AddCloseAtToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :close_at, :timestamp
  end
end
