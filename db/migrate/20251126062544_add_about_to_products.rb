class AddAboutToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :about, :text
  end
end
