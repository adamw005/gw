Rails.configuration.stripe = {
  :publishable_key => 'pk_test_PLdY3PPDgPuw7G6rmXJc9yMv', #ENV['PUBLISHABLE_KEY'],
  :secret_key      => 'sk_test_GyJcAWcxc5EXtzaH5TcUMEyJ' #ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
