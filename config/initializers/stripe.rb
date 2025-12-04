stripe_secret_key =
  ENV["STRIPE_SECRET_KEY"] ||
  Rails.application.credentials.dig(:stripe, :secret_key) ||
  "sk_test_dummy_key_1234567890123456"

Stripe.api_key = stripe_secret_key
