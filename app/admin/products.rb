ActiveAdmin.register Product do

  # Show validation errors on form
  form do |f|
    f.semantic_errors *f.object.errors.attribute_names

    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :about, as: :text
      f.input :specifications, as: :text
      f.input :price
      f.input :quantity
      f.input :sku
      f.input :is_new
      f.input :is_on_sale
      f.input :last_updated

      f.input :categories, as: :check_boxes, collection: Category.all

      # Multiple image upload
      f.input :images, as: :file, input_html: { multiple: true }
    end

    f.actions
  end

  # Strong parameters
  permit_params :name, :description, :about, :specifications,
                :price, :quantity, :sku, :is_new, :is_on_sale, :last_updated,
                category_ids: [], images: []

  # Filters — avoid broken auto-filters
  remove_filter :product_categories
  remove_filter :images_attachments
  remove_filter :images_blobs

  filter :name
  filter :price
  filter :categories
  filter :created_at

  # Index page
  index do
    selectable_column
    id_column
    column :name
    column :price
    column :categories do |product|
      product.categories.map(&:name).join(", ")
    end
    column :created_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :name
      row :description
      row :about
      row :specifications
      row :price
      row :quantity
      row :sku
      row :is_new
      row :is_on_sale
      row :last_updated
      row :categories do |product|
        product.categories.map(&:name).join(", ")
      end

      row "Images" do |product|
        div do
          product.images.each do |img|
            span do
              image_tag url_for(img), style: "max-width: 150px; margin-right: 10px;"
            end
          end
        end
      end
    end
  end

end
