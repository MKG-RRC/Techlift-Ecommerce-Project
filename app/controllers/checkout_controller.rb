# frozen_string_literal: true

class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
    @subtotal = calculate_subtotal
    @taxes = calculate_taxes
    @total = @subtotal + @taxes.values.sum
    @address = current_user.address || Address.new
  end

  def create
    @cart = session[:cart] || {}

    if @cart.empty?
      redirect_to cart_path, alert: t('flash.checkout.cart_empty')
      return
    end

    # Save address
    address = current_user.address || current_user.build_address
    if address.update(address_params)
      # Create Stripe session
      begin
        subtotal = calculate_subtotal
        taxes = calculate_taxes
        total_amount = ((subtotal + taxes.values.sum) * 100).round

        stripe_session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          mode: 'payment',
          line_items: [{
            quantity: 1,
            price_data: {
              currency: 'cad',
              unit_amount: total_amount,
              product_data: { name: 'TechLift Store Order' }
            }
          }],
          success_url: "#{order_success_url}?session_id={CHECKOUT_SESSION_ID}",
          cancel_url: checkout_url
        )

        redirect_to stripe_session.url, allow_other_host: true
      rescue Stripe::StripeError => e
        redirect_to checkout_path, alert: "Payment error: #{e.message}"
      end
    else
      redirect_to checkout_path, alert: t('flash.checkout.address_missing')
    end
  end

  def success
    if params[:session_id].present?
      redirect_to order_success_path(session_id: params[:session_id])
    else
      redirect_to root_path, alert: t('flash.checkout.missing_session')
    end
  end

  private

  def calculate_subtotal
    cart = session[:cart] || {}
    cart.sum do |id, qty|
      product = Product.find_by(id: id)
      product ? product.price * qty : 0
    end
  end

  def calculate_taxes
    province = current_user.address&.province || current_user.province
    subtotal = calculate_subtotal

    calculate_taxes_for(province, subtotal)
  end

  def address_params
    params.require(:address).permit(:street, :city, :postal_code, :province_id)
  end
end
