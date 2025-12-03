# frozen_string_literal: true

class PageContent < ApplicationRecord
  # Validations
  validates :title, :slug, :content, presence: true

  # Ransack allowlists
  def self.ransackable_attributes(_auth_object = nil)
    %w[
      id
      title
      slug
      content
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
