class CheckoutController < ApplicationController
  def create
    product = Product.find_by(id: params[:id])
    @session = Stripe::Checkout::Session.create({
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
      success_url: root_url,
      cancel_url: root_url,
    })

    redirect_to @session.url, allow_other_host: true
  end
end
