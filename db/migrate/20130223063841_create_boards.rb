class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.references :plan

      t.timestamps
    end
    add_index :boards, :plan_id

    add_column :comments, :type, :string
    add_column :comments, :board_id, :integer
  end
end
