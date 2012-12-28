class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :plan_id
      t.timestamp :candidate_day
      t.boolean :adopt_flag, default: false

      t.timestamps
    end
  end
end
