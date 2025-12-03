# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  # Calculates GST/PST/HST totals for a given province and subtotal.
  def calculate_taxes_for(province, subtotal)
    return { gst: 0, pst: 0, hst: 0 } if province.blank? || subtotal.nil?

    subtotal = subtotal.to_d

    {
      gst: subtotal * (province.gst || 0),
      pst: subtotal * (province.pst || 0),
      hst: subtotal * (province.hst || 0)
    }
  end
end
