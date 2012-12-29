class AddCheersCountToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :cheers_count, :integer, default: 0
    add_column :plans, :favorites_count, :integer, default: 0
  end
end
