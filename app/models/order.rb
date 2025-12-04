# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy

  attribute :status, :string, default: 'new'

  enum status: {
    new: 'new',
    paid: 'paid',
    shipped: 'shipped'
  }, _prefix: :status

  validates :status, presence: true, inclusion: { in: statuses.keys }

  # ---------------------------
  # Ransack allowlists
  # ---------------------------
  def self.ransackable_associations(_auth_object = nil)
    %w[
      user
      order_items
    ]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      id
      status
      subtotal
      gst
      pst
      hst
      total
      payment_status
      stripe_payment_id
      stripe_session_id
      province_id
      created_at
      updated_at
      user_id
    ]
  end
end
