class AddStripeFieldsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :stripe_payment_id, :string
    add_column :orders, :payment_status, :string
  end
end
