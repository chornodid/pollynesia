class AddOpenDateAndCloseDateToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :open_date, :datetime
    add_column :polls, :close_date, :datetime
  end
end
