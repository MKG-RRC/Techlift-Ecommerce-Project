class AddDetailsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :quantity, :integer
    add_column :products, :sku, :string
    add_column :products, :is_new, :boolean
    add_column :products, :is_on_sale, :boolean
    add_column :products, :last_updated, :datetime
  end
end
