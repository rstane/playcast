class AddAdminFlagToUsersAndPlans < ActiveRecord::Migration
  def change
    add_column :users, :admin_flag, :boolean, default: false
    add_column :plans, :admin_flag, :boolean, default: false
  end
end
