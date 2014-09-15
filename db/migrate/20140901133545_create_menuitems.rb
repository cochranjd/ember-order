class CreateMenuitems < ActiveRecord::Migration
  def change
    create_table :menuitems do |t|
      t.string :title
      t.text :description
      t.integer :price_in_cents

      t.timestamps
    end
  end
end
