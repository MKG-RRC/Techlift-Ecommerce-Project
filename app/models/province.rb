# frozen_string_literal: true

class Province < ApplicationRecord
  has_many :users, dependent: :nullify

  validates :name, :gst, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name gst pst hst created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['users']
  end
end
