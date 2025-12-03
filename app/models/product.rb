# frozen_string_literal: true

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
  # Scopes
  # ------------------------
  scope :on_sale, -> { where(is_on_sale: true) }
  scope :recently_added, -> { order(created_at: :desc) }

  # ------------------------
  # Ransack allowlists
  # ------------------------
  def self.ransackable_attributes(_auth_object = nil)
    %w[
      id
      name
      description
      about
      specifications
      price
      quantity
      sku
      is_new
      is_on_sale
      last_updated
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[
      categories
      product_categories
      images_attachments
      images_blobs
    ]
  end
end
