class AddEmailLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :location, :string
  end
end
