class AddFlagsToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :decide_flag, :boolean, default: false
    add_column :plans, :entry_close_flag, :boolean, default: false
  end
end
