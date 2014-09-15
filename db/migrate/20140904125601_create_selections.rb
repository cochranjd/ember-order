class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|

      t.references :order, index: true
      t.references :menuitem, index: true

      t.timestamps
    end
  end
end
