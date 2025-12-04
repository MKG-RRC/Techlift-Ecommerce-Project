ActiveAdmin.register Order do

  # ---------------------------
  # Strong Parameters
  # ---------------------------
  permit_params :user_id, :status, :subtotal, :gst, :pst, :hst, :total

  # ---------------------------
  # Index Page
  # ---------------------------
  index do
    selectable_column
    id_column
    column :user
    column :status
    column :subtotal
    column :gst
    column :pst
    column :hst
    column :total
    column :created_at
    actions
  end

  # ---------------------------
  # Filters
  # ---------------------------
  filter :user
  filter :status, as: :select, collection: -> { Order.statuses.keys }
  filter :subtotal
  filter :gst
  filter :pst
  filter :hst
  filter :total
  filter :created_at

  # ---------------------------
  # Form
  # ---------------------------
  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :user
      f.input :status, as: :select,
                       collection: Order.statuses.keys.map { |s| [s.titleize, s] },
                       include_blank: false
      f.input :subtotal
      f.input :gst
      f.input :pst
      f.input :hst
      f.input :total
    end

    f.actions
  end
end
