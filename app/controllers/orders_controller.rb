# frozen_string_literal: true

# FILE: app/controllers/orders_controller.rb

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: :show

  def index
    @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
  end

  def show; end

  def success
    session_id = params[:session_id]

    return redirect_to root_path, alert: t('flash.orders.missing_session') if session_id.blank?

    stripe_session = retrieve_stripe_session(session_id)
    return redirect_to root_path, alert: t('flash.orders.invalid_session') unless stripe_session

    cart = session[:cart] || {}
    return redirect_to products_path, alert: t('flash.orders.empty_cart') if cart.empty?

    products = Product.where(id: cart.keys)
    subtotal = products.sum { |product| product.price * cart[product.id.to_s].to_i }

    province = current_user.province || current_user.address&.province
    return redirect_to checkout_path, alert: t('flash.orders.missing_province') if province.nil?

    taxes = calculate_taxes_for(province, subtotal)

    order = current_user.orders.create!(
      subtotal: subtotal,
      gst: taxes[:gst],
      pst: taxes[:pst],
      hst: taxes[:hst],
      total: subtotal + taxes.values.sum,
      status: 'paid',
      payment_status: 'paid',
      stripe_payment_id: stripe_session.payment_intent,
      stripe_session_id: session_id,
      province: province
    )

    products.each do |product|
      qty = cart[product.id.to_s].to_i
      next if qty <= 0

      order.order_items.create!(
        product: product,
        product_name: product.name,
        quantity: qty,
        price_at_purchase: product.price,
        price: product.price
      )
    end

    session[:cart] = {}

    redirect_to order_path(order), notice: t('flash.orders.payment_success')
  end

  private

  def set_order
    @order = current_user.orders.includes(:order_items).find(params[:id])
  end

  def retrieve_stripe_session(session_id)
    Stripe::Checkout::Session.retrieve(session_id)
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe session lookup failed: #{e.message}")
    nil
  end
end
