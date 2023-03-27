class CheckoutController < ApplicationController
  def create
    @session = Stripe::Checkout::Session.create({
      customer: current_user.stripe_customer_id,
      payment_method_types: ["card"],
      line_items: @cart.collect { |item| item.to_builder.attributes! },
      mode: 'payment',
      success_url: success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: cancel_url,
    })

    redirect_to @session.url, allow_other_host: true
  end

  def success
    if params[:session_id].present?
      session.delete(:cart)
      # session[:cart] = []
      @session_with_expand = Stripe::Checkout::Session.retrieve({ id: params[:session_id], expand: ["line_items"] })
    else
      redirect_to cancel_path, alert: "No info to display"
    end
  end

  def cancel; end
end
