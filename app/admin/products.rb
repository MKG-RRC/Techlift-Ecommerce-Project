ActiveAdmin.register Product do

  permit_params :name, :description, :price, :category_id, :image

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :price
      f.input :category, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }
      f.input :image, as: :file
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :category
    column :price
    column :created_at
    actions
  end

end
