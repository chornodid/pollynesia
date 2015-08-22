class ChangeIsAdminInUsers < ActiveRecord::Migration
  def up
    change_column :users, :is_admin, :integer, null: true
  end

  def down
    change_column :users, :is_admin, :integer, null: false
  end
end
