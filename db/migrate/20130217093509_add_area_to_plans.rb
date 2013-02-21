class AddAreaToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :area, :string
  end
end
