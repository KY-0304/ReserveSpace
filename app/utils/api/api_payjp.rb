class ApiPayjp
  def self.pay(amount, token, currency: 'jpy')
    Payjp.api_key = ENV['PAYJP_TEST_SECRET_KEY']
    Payjp::Charge.create(
        amount: amount,
        card: token,
        currency: currency
      )
  end
end
