# Module for Splitting the Response to simple components.
module K2ProcessResult
  # Confirm Truth value and carry out splitting.
  def self.process(the_body)
    raise ArgumentError.new("Nil Request Body Argument!") if the_body.blank?
    K2ProcessResult.check_type(the_body)
  end

  # Check the Event Type.
  def self.check_topic(the_body)
    case the_body.dig("topic")
    when "buygoods_transaction_received"
      puts "Buy Goods Transaction Received."
      K2ProcessResult.return_hash(BuyGoods.new.components(the_body))
    when "buygoods_transaction_reversed"
      puts "Buy Goods Transaction Reversed."
      K2ProcessResult.return_hash(Reversal.new.components(the_body))
    when "settlement_transfer_completed"
      puts "Settlement Transaction."
      K2ProcessResult.return_hash( Settlement.new.components(the_body))
    when "customer_created"
      puts "Customer Created."
      K2ProcessResult.return_hash(CustomerCreated.new.components(the_body))
    when "payment_request"
      puts "STK Push Payment Request Result."
      K2ProcessResult.return_hash(K2ProcessStk.new.components(the_body))
    when "pay_result"
      puts "PAY Payment Request Result."
      K2ProcessResult.return_hash(K2ProcessPay.new.components(the_body))
    else
      raise ArgumentError.new("No Other Specified Event!")
    end
  end

  def self.return_hash(number = 0, instance_hash=HashWithIndifferentAccess.new, obj)
    while number < obj.instance_variables.length
      obj.instance_variables.each do |value|
        instance_hash[:"#{value.to_s.tr('@', '')}"] = obj.instance_variable_get(value)
        number+=1
      end
    end
    return instance_hash
  end

end