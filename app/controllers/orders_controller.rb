class OrdersController < ApplicationController
  before_action :authenticate_user!

  def show
    @order = current_user.orders.find(params[:id])
  end

  def success
  session_id = params[:session_id]
  stripe_session = Stripe::Checkout::Session.retrieve(session_id)

  return redirect_to root_path unless stripe_session

  # Create order after payment is confirmed
  order = current_user.orders.create!(
    subtotal: calculate_subtotal,
    gst: calculate_taxes[:gst],
    pst: calculate_taxes[:pst],
    hst: calculate_taxes[:hst],
    total: calculate_subtotal + calculate_taxes.values.sum,
    stripe_payment_id: stripe_session.payment_intent,
    payment_status: "paid",
    province_id: current_user.province_id
  )

  session[:cart] = {}

  redirect_to order_path(order), notice: "Payment successful!"
end

end
