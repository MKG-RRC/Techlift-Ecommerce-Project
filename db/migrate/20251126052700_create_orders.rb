class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.decimal :subtotal
      t.decimal :gst
      t.decimal :pst
      t.decimal :hst
      t.decimal :total

      t.timestamps
    end
  end
end
