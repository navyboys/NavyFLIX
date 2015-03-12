module StripeWrapper
  class Charge
    def self.create(options={})      
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      Stripe::Charge.create(
        amount: options[:amount],
        currency: 'usd',
        card: options[:card],
        description: options[:description]
      )
    end
  end
end