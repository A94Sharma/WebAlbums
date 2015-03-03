Rails.configuration.stripe = {
  :publishable_key => 'pk_test_S550RwdvFdxqDNzWxmBYIdX3',
  :secret_key      => 'sk_test_mL5YJRK7c0N278UVcqmGr0od'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
