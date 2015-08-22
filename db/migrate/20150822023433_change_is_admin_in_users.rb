class ChangeIsAdminInUsers < ActiveRecord::Migration
  def up
    change_column :users, :is_admin, :integer, null: true
  end

  def down
    User.all.where(is_admin: nil).update_all(is_admin: 0)
    change_column :users, :is_admin, :integer, null: false
  end
end
