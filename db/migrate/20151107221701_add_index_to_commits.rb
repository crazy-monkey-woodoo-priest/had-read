class AddIndexToCommits < ActiveRecord::Migration
  def change
    add_index :commits, :author
  end
end
