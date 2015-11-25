class CreateSubways < ActiveRecord::Migration
  def change
    create_table :subways do |t|
      t.string :name
      t.string :line
			t.string :area
      t.string :address
      t.float :location_y
			t.float :location_x

      t.timestamps null: false
    end
  end
end
