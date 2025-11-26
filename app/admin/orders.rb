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
  filter :status
  filter :subtotal
  filter :gst
  filter :pst
  filter :hst
  filter :total
  filter :created_at
end
