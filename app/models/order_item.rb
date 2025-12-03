# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # ---------------------------
  # Ransack allowlists
  # ---------------------------
  def self.ransackable_attributes(_auth_object = nil)
    %w[
      id
      order_id
      product_id
      quantity
      price_at_purchase
      price
      product_name
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[
      order
      product
    ]
  end
end
