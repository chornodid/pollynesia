class ChangeIpAddressInVotes < ActiveRecord::Migration
  def up
    change_column :votes, :ip_address, :string
  end

  def down
    change_column :votes, :ip_address, :string, limit: 15
  end
end
