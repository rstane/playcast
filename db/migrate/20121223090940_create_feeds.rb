class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :type
      t.integer :user_id
      t.integer :plan_id
      t.integer :entry_id
      t.integer :comment_id
      t.string :happen

      t.timestamps
    end
  end
end
