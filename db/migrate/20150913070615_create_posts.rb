class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :user_id
			t.integer :impressions_count, :default => 0
      t.timestamps
    end
    add_index :posts, :user_id
  end
end
