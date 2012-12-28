class AddScheduleIdToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :schedule_id, :integer
  end
end
