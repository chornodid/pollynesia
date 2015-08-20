class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.references :user
      t.string :title
      t.string :status

      t.timestamps null: false
    end
  end
end
