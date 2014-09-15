class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :email
      t.string :token
      t.string :invitees
      t.string :status
      t.string :container_id
      t.boolean :is_master
      t.integer :total_price_in_cents
      t.string :cc_number
      t.string :cc_expire
      t.string :cc_name
      t.boolean :is_paid

      t.timestamps
    end
  end
end
