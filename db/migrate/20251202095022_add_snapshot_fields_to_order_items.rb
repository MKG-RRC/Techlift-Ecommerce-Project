class AddSnapshotFieldsToOrderItems < ActiveRecord::Migration[7.0]
  def change
    # Only add product_name; price already exists
    add_column :order_items, :product_name, :string
  end
end
