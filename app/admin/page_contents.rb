ActiveAdmin.register PageContent do
  permit_params :title, :slug, :content

  # INDEX PAGE
  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :updated_at
    actions
  end

  # FORM PAGE
  form do |f|
    f.inputs "Page Information" do
      f.input :title
      f.input :slug, input_html: { disabled: true }   # Protect the slug
      f.input :content, as: :text, input_html: { rows: 12 }
    end
    f.actions
  end
end
