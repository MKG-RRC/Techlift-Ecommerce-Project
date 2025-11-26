class Product < ApplicationRecord
  # ------------------------
  # Associations
  # ------------------------
  has_many_attached :images

  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories

  # ------------------------
  # Validations
  # ------------------------
  validates :name, :description, :price, :about, :specifications, presence: true


  # ------------------------
  # Ransack allowlists
  # ------------------------
  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "name",
      "description",
      "about",
      "specifications",
      "price",
      "quantity",
      "sku",
      "is_new",
      "is_on_sale",
      "last_updated",
      "created_at",
      "updated_at"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [
      "categories",
      "product_categories",
      "images_attachments",
      "images_blobs"
    ]
  end
end
