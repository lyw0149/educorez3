class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :name
      t.string :area
			t.string :address
			t.float :location_x
			t.float :location_y
      t.timestamps null: false
    end
  end
end
