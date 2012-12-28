class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :user_id
      t.integer :plan_id
      t.integer :entry_id
      t.integer :schedule_id

      t.timestamps
    end
  end
end
