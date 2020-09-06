class ApiPayjp
  def self.charge(amount, token, currency: 'jpy')
    Payjp.api_key = ENV['PAYJP_TEST_SECRET_KEY']
    Payjp::Charge.create(
      amount: amount,
      card: token,
      currency: currency
    )
  end

  def self.get_charge(charge_id)
    Payjp.api_key = ENV['PAYJP_TEST_SECRET_KEY']
    Payjp::Charge.retrieve(charge_id)
  end

  def self.refund(charge)
    Payjp.api_key = ENV['PAYJP_TEST_SECRET_KEY']
    charge.refund
  end
end
