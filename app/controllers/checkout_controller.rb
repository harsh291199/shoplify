class CheckoutController < ApplicationController
  def create
    product = Product.find_by(id: params[:id])
    @session = Stripe::Checkout::Session.create({
      customer: current_user.stripe_customer_id,
      payment_method_types: ["card"],
      line_items: [
        {
          price_data: {
            currency: "inr",
            product_data: {
              name: product.name,
            },
            unit_amount: (product.price * 100),
          },
          quantity: 1,
        },
      ],
      mode: 'payment',
      success_url: success_url,
      cancel_url: cancel_url,
    })

    redirect_to @session.url, allow_other_host: true
  end

  def success
  end

  def cancel
  end
end
