class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  # ---------------------------
  # Ransack allowlists
  # ---------------------------
  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "status",
      "subtotal",
      "gst",
      "pst",
      "total",
      "created_at",
      "updated_at",
      "user_id"
    ]
  end


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
    "created_at",
    "updated_at",
    "user_id"
  ]
end

end
