module K2CommonWebhook
  def self.components(the_body, amount, currency, reference, origination_time, status)
    amount = the_body.dig("event", "resource", "amount")
    currency = the_body.dig("event", "resource", "currency")
    reference = the_body.dig("event", "resource", "reference")
    origination_time = the_body.dig("event", "resource", "origination_time")
    status = the_body.dig("event", "resource", "status")
  end
end