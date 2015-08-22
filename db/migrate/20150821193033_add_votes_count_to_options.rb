class AddVotesCountToOptions < ActiveRecord::Migration
  def up
    add_column :options, :votes_count, :integer, default: 0

    Option.reset_column_information
    Option.all.each do |option|
      counter = option.votes.count
      next if counter.zero?
      say("update option ##{option.id} votes counter = #{counter}")
      Option.update_counters(option.id, votes_count: counter)
    end
  end

  def down
    remove_column :options, :votes_count
  end
end
