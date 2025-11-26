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

    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    # Save or update address
    address = current_user.address || current_user.build_address
    address.update(address_params)

    subtotal = calculate_subtotal
    taxes    = calculate_taxes

    # Create order
    order = current_user.orders.create!(
      subtotal:    subtotal,
      gst:         taxes[:gst],
      pst:         taxes[:pst],
      hst:         taxes[:hst],
      total:       subtotal + taxes.values.sum,
      province_id: current_user.province_id
    )

    # Create order items
    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      order.order_items.create!(
        product:  product,
        quantity: quantity,
        price:    product.price
      )
    end

    # Clear cart
    session[:cart] = {}

    redirect_to order_path(order), notice: "Order placed successfully!"
  end

  private

  # 🧹 Automatically remove invalid product IDs
  def clean_invalid_cart_items
    cart = session[:cart] || {}
    valid = cart.select { |id, _qty| Product.exists?(id) }
    session[:cart] = valid
  end

  # 💰 Safe subtotal that won’t crash
  def calculate_subtotal
    @cart.sum do |id, qty|
      product = Product.find_by(id: id)
      product ? product.price * qty : 0
    end
  end

  # 🧾 Safe tax calculation
  def calculate_taxes
    province = current_user.province
    subtotal = calculate_subtotal

    return { gst: 0, pst: 0, hst: 0 } unless province

    {
      gst: subtotal * province.gst,
      pst: subtotal * province.pst,
      hst: subtotal * province.hst
    }
  end

  def address_params
    params.require(:address).permit(:street, :city, :postal_code, :province_id)
  end
end
