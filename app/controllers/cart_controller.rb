# frozen_string_literal: true

class CartController < ApplicationController
  before_action :initialize_cart

  def show
    @cart_items = @cart.filter_map do |product_id, qty|
      product = Product.find_by(id: product_id)
      next unless product

      {
        product: product,
        quantity: qty,
        subtotal: qty * product.price
      }
    end

    @total = @cart_items.sum { |i| i[:subtotal] }
  end

  def add
    id = params[:id].to_s
    @cart[id] ||= 0
    @cart[id] += 1
    save_cart
    redirect_back_or_to(products_path)
  end

  def remove
    @cart.delete(params[:id].to_s)
    save_cart
    redirect_to cart_path
  end

  def update
    id = params[:id].to_s
    qty = params[:quantity].to_i

    qty <= 0 ? @cart.delete(id) : @cart[id] = qty

    save_cart
    redirect_to cart_path
  end

  private

  def initialize_cart
    session[:cart] ||= {}
    @cart = session[:cart]
  end

  def save_cart
    session[:cart] = @cart
  end
end
