class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.text :image_url
      t.text :place
      t.string :budget
      t.integer :min_people
      t.integer :max_people
      t.timestamp :publish_start_at
      t.timestamp :publish_end_at
      t.text :target_people

      t.timestamps
    end
  end
end
