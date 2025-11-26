class PageContent < ApplicationRecord
  # Validations
  validates :title, :slug, :content, presence: true

  # Ransack allowlists
  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "title",
      "slug",
      "content",
      "created_at",
      "updated_at"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
