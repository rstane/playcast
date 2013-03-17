class AddGenderToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :male_min, :integer, default: 2
    add_column :plans, :male_max, :integer
    add_column :plans, :female_min, :integer, default: 2
    add_column :plans, :female_max, :integer
  end
end
