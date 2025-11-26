class User < ApplicationRecord
  belongs_to :province, optional: true
  has_many :orders

  # Devise modules already included

  def self.ransackable_attributes(auth_object = nil)
    ["id", "email", "first_name", "last_name", "city", "postal_code", "province_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders", "province"]
  end
end
