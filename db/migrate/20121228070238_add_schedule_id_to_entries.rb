class AddScheduleIdToEntries < ActiveRecord::Migration
  def change
#    add_column :entries, :schedule_id, :integer
    add_column :entries, :comment, :text
  end
end
