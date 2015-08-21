class CreateVote < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :option
      t.references :user
      t.string :ip_address, limit: 15

      t.timestamps null: false
    end

    add_index :votes, [:option_id, :ip_address]
  end
end
