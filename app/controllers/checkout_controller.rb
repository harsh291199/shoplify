class CheckoutController < ApplicationController
  def create
    product = Product.find_by(id: params[:id])
    @session = Stripe::Checkout::Session.create({
      customer: current_user.stripe_customer_id,
      payment_method_types: ["card"],
      line_items: @cart.collect { |item| item.to_builder.attributes! },
      mode: 'payment',
      success_url: success_url,
      cancel_url: cancel_url,
    })

    redirect_to @session.url, allow_other_host: true
  end

  def success; end

  def cancel; end
end
