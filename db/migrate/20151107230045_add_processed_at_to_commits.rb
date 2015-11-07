class AddProcessedAtToCommits < ActiveRecord::Migration
  def change
    add_column :commits, :processed_at, :datetime
  end
end
