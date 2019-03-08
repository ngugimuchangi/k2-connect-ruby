# Module for Splitting the Response to simple components.
module K2ProcessResult
  # Confirm Truth value and carry out splitting.
  def self.process(the_body)
    raise ArgumentError.new("Nil Request Body Argument!") if the_body.blank?
    K2ProcessResult.check_topic(the_body)
  end

  # Check the Event Type.
  def self.check_topic(the_body)
    case the_body.dig("topic")
    when "buygoods_transaction_received"
      puts "Buy Goods Transaction Received."
      bg = BuyGoods.new.components(the_body)
      K2ProcessResult.return_obj_array(bg)
    when "buygoods_transaction_reversed"
      puts "Buy Goods Transaction Reversed."
      K2ProcessResult.return_obj_array(Reversal.new.components(the_body))
    when "settlement_transfer_completed"
      puts "Settlement Transaction."
      K2ProcessResult.return_obj_array(Settlement.new.components(the_body))
    when "customer_created"
      puts "Customer Created."
      K2ProcessResult.return_obj_array(CustomerCreated.new.components(the_body))
    when "payment_request"
      puts "STK Push Payment Request Result."
      K2ProcessResult.return_obj_array(K2ProcessStk.new.components(the_body))
    when "pay_result"
      puts "PAY Payment Request Result."
      K2ProcessResult.return_obj_array(K2ProcessPay.new.components(the_body))
    else
      raise ArgumentError.new("No Other Specified Event!")
    end
  end

  # def self.return_obj_hash(number = 0, instance_hash=HashWithIndifferentAccess.new, obj)
  #   while number < obj.instance_variables.length
  #     obj.instance_variables.each do |value|
  #       instance_hash[:"#{value.to_s.tr('@', '')}"] = obj.instance_variable_get(value)
  #       number+=1
  #     end
  #   end
  #   return instance_hash
  # end

  def self.return_obj_array(instance_array=Array.new, obj)
    obj.instance_variables.each do |value|
      instance_array << obj.instance_variable_get(value)
    end
    return instance_array
  end

end