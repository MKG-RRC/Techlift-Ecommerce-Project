# frozen_string_literal: true

class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :trackable

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      id
      email
      created_at
      updated_at
      sign_in_count
      current_sign_in_at
      last_sign_in_at
      current_sign_in_ip
      last_sign_in_ip
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
