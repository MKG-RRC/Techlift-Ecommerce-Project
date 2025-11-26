class Province < ApplicationRecord
  has_many :users

  validates :name, :gst, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "gst", "pst", "hst", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["users"]
  end
end
