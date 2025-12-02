class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :clean_invalid_cart_items

  def show
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)

    @subtotal = calculate_subtotal
    @taxes = calculate_taxes
    @total = @subtotal + @taxes.values.sum

    @address = current_user.address || Address.new
  end

  def process_order
    @cart = session[:cart] || {}

    # Return error if cart is empty
    if @cart.empty?
      return render json: { error: "Cart is empty" }, status: 400
    end

    # Save/update address
    address = current_user.address || current_user.build_address

    address_data = {
      street: params[:street],
      city: params[:city],
      postal_code: params[:postal_code],
      province_id: params[:province_id]
    }

    unless address.update(address_data)
      Rails.logger.error("Address update failed: #{address.errors.full_messages}")
      return render json: { error: "Invalid address: #{address.errors.full_messages.join(', ')}" }, status: 400
    end

    # Calculate totals
    subtotal = calculate_subtotal
    taxes = calculate_taxes
    total_amount = ((subtotal + taxes.values.sum) * 100).round  # Stripe uses cents

    # Log for debugging
    Rails.logger.info("Creating Stripe session: subtotal=#{subtotal}, taxes=#{taxes}, total=#{total_amount}")

    begin
      stripe_session = Stripe::Checkout::Session.create(
        payment_method_types: ["card"],
        mode: "payment",
        line_items: [
          {
            quantity: 1,
            price_data: {
              currency: "cad",
              unit_amount: total_amount,
              product_data: {
                name: "TechLift Store Order"
              }
            }
          }
        ],
        success_url: "#{request.base_url}/order/success?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "#{request.base_url}/checkout"
      )

      render json: stripe_session
    rescue Stripe::StripeError => e
      Rails.logger.error("Stripe error: #{e.message}")
      render json: { error: "Payment processing error: #{e.message}" }, status: 500
    rescue => e
      Rails.logger.error("Unexpected error: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      render json: { error: "An unexpected error occurred: #{e.message}" }, status: 500
    end
  end

  private

  # 🧹 Automatically remove invalid product IDs
  def clean_invalid_cart_items
    cart = session[:cart] || {}
    valid = cart.select { |id, _qty| Product.exists?(id) }
    session[:cart] = valid
  end

  # 💰 Safe subtotal that won't crash
  def calculate_subtotal
    @cart ||= session[:cart] || {}
    @cart.sum do |id, qty|
      product = Product.find_by(id: id)
      product ? product.price * qty : 0
    end
  end

  # 🧾 Safe tax calculation
  def calculate_taxes
    # FIXED: Get province from address, not directly from user
    address = current_user.address
    province = address&.province
    subtotal = calculate_subtotal

    return { gst: 0, pst: 0, hst: 0 } unless province

    {
      gst: subtotal * (province.gst || 0),
      pst: subtotal * (province.pst || 0),
      hst: subtotal * (province.hst || 0)
    }
  end
end