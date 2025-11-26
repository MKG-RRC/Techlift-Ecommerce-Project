class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image

  validates :name, :price, :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "description", "price", "category_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end
end
