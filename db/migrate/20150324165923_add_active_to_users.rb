class AddActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activa, :boolean, default: true
  end
end
