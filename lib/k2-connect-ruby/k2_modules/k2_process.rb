# Module for Splitting the Response to simple components.
module K2ProcessResult
  # Confirm Truth value and carry out splitting.
  def self.process(the_body)
    raise ArgumentError.new("Empty/Nil Request Body Argument!") if the_body.blank?
    K2ProcessResult.check_topic(the_body)
  end

  # Check the Event Type.
  def self.check_topic(the_body)
    case the_body.dig("topic")
    when "buygoods_transaction_received"
      puts "Buy Goods Transaction Received."
      buy_goods = BuyGoods.new
      buy_goods.components(the_body)
      K2ProcessResult.return_obj_array(buy_goods)
    when "buygoods_transaction_reversed"
      puts "Buy Goods Transaction Reversed."
      reversals = Reversal.new
      reversals.components(the_body)
      K2ProcessResult.return_obj_array(reversals)
    when "settlement_transfer_completed"
      puts "Settlement Transaction."
      settlement = Settlement.new
      settlement.components(the_body)
      K2ProcessResult.return_obj_array(settlement)
    when "customer_created"
      puts "Customer Created."
      customer = CustomerCreated.new
      customer.components(the_body)
      K2ProcessResult.return_obj_array(customer)
    when "payment_request"
      puts "STK Push Payment Request Result."
      stk_result = K2ProcessStk.new
      stk_result.components(the_body)
      K2ProcessResult.return_obj_array(stk_result)
    when "pay_result"
      puts "PAY Payment Request Result."
      pay_result = K2ProcessPay.new
      pay_result.components(the_body)
      K2ProcessResult.return_obj_array(pay_result)
    else
      raise ArgumentError.new("No Other Specified Event!")
    end
  end

  # TODO, Identify which is better, Hash, or Array
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