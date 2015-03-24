class ChangeActivaToActiveToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :activa, :active
  end
end
