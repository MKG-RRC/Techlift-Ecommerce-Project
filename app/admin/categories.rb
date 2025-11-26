ActiveAdmin.register Category do

  # Allow only the :name attribute to be assigned
  permit_params :name, product_ids: []

  # INDEX PAGE
  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  # FORM
  form do |f|
    f.inputs "Category Details" do
      f.input :name

      # allow assigning products to a category (optional)
      f.input :products, as: :check_boxes, collection: Product.all
    end
    f.actions
  end

  # SHOW PAGE (optional but clean)
  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
      row "Products in this Category" do |category|
        ul do
          category.products.each do |product|
            li link_to(product.name, admin_product_path(product))
          end
        end
      end
    end
  end

end
