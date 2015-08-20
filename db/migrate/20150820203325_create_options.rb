class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.references :poll
      t.string :title
      t.integer :position

      t.timestamps null: false
    end
  end
end
