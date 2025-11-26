class RemoveCategoryIdFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :category_id, :integer
  end
end
