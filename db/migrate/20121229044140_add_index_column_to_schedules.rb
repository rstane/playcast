class AddIndexColumnToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :number, :integer
  end
end
