class CreateExtras < ActiveRecord::Migration
  def change
    create_table :extras do |t|
			t.string	:title
			t.text	:content

      t.timestamps null: false
    end
  end
end
