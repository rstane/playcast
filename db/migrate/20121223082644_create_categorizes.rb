class CreateCategorizes < ActiveRecord::Migration
  def change
    create_table :categorizes do |t|
      t.integer :plan_id
      t.integer :category_id

      t.timestamps
    end
  end
end
