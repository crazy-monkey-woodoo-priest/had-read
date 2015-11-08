class AddAvatarToCommits < ActiveRecord::Migration
  def change
    add_column :commits, :avatar, :string
  end
end
