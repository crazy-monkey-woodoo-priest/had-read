class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :sha
      t.string :author
      t.text :message
      t.jsonb :links
      t.datetime :commited_at

      t.timestamps null: false
    end
  end
end
