class CreateWillEntries < ActiveRecord::Migration
  def change
    create_table :will_entries do |t|
      t.references :plan
      t.references :user

      t.timestamps
    end
    add_index :will_entries, :plan_id
    add_index :will_entries, :user_id
  end
end
