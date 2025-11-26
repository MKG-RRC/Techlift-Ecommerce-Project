class User < ApplicationRecord
  # Enable Devise authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy
  has_one :address, dependent: :destroy

  # Admin search filters
  def self.ransackable_attributes(_auth_object = nil)
    ["id", "email", "first_name", "last_name", "city", "postal_code",
     "province_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["orders", "province", "address"]
  end
end
