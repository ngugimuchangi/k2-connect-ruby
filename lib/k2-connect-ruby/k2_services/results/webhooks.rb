class WebhookTransaction < K2Result
  # Can also implement Customer Created from Here
  attr_accessor :msisdn,
                :first_name,
                :middle_name,
                :last_name

end

class CommonWebhook < WebhookTransaction
  attr_accessor :reference,
                :origination_time,
                :status

  # For The General Webhook
  def components(the_body)
    super
    @amount = the_body.dig("event", "resource", "amount")
    @currency = the_body.dig("event", "resource", "currency")
    @reference = the_body.dig("event", "resource", "reference")
    @origination_time = the_body.dig("event", "resource", "origination_time")
    @status = the_body.dig("event", "resource", "status")
  end

end

class CustomerCreated < WebhookTransaction
  # For The Customer Created Webhook
  def components(the_body)
    super
    @msisdn = the_body.dig("event", "resource", "msisdn")
    @first_name = the_body.dig("event", "resource", "first_name")
    @middle_name = the_body.dig("event", "resource", "middle_name")
    @last_name = the_body.dig("event", "resource", "last_name")
  end
end

class BuyGoods < CommonWebhook
  attr_accessor :till_number,
                :system

  # For The BuyGoods Received Webhook
  def components(the_body)
    super
    @msisdn = the_body.dig("event", "resource", "sender_msisdn")
    @till_number = the_body.dig("event", "resource", "till_number")
    @system = the_body.dig("event", "resource", "system")
    @first_name = the_body.dig("event", "resource", "sender_first_name")
    @middle_name = the_body.dig("event", "resource", "sender_middle_name")
    @last_name = the_body.dig("event", "resource", "sender_last_name")
  end

end

class Reversal < BuyGoods
  attr_accessor :reversal_time
  # For The BuyGoods Reversed Webhook
  def components(the_body)
    super
    @reversal_time = the_body.dig("event", "resource", "reversal_time")
  end

end

class Settlement < CommonWebhook
  attr_accessor :destination,
                :destination_type,
                :transfer_time,
                :transfer_type,
                :destination_mm_system
  # For The Settlement Transfer Webhook
  def components(the_body)
    super
    @transfer_time = the_body.dig("event", "resource", "transfer_time")
    @transfer_type = the_body.dig("event", "resource", "transfer_type")
    @destination = the_body.dig("event", "resource", "destination")
    @destination_type = the_body.dig("event", "resource", "destination", "type")
    @msisdn = the_body.dig("event", "resource", "destination", "msisdn")
    @destination_mm_system = the_body.dig("event", "resource", "destination", "mm_system")
  end

end