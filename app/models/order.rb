class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy

  # ---------------------------
  # Ransack allowlists
  # ---------------------------
  def self.ransackable_associations(auth_object = nil)
    [
      "user",
      "order_items"
    ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "status",
      "subtotal",
      "gst",
      "pst",
      "hst",
      "total",
      "payment_status",
      "stripe_payment_id",
      "stripe_session_id",
      "province_id",
      "created_at",
      "updated_at",
      "user_id"
    ]
  end
end
