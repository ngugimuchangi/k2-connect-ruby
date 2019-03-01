# TODO, David Nino, take a look at the check_type
# Module for Splitting the Response to simple components
module K2Split
  # Confirm Truth value and carry out splitting
  def self.judge_truth(the_body, truth_value)
    raise K2EmptyRequestBody.new if the_body.nil? || the_body==""
    if truth_value
      K2Split.check_type(the_body, truth_value)
    else
      raise K2FalseTruthValue.new
    end
  # rescue K2FalseTruthValue => k3
  #   return false
  # rescue K2EmptyRequestBody => k2
  #   return false
  rescue StandardError => e
    puts(e.message)
  end

  # Check the Event Type.
  def self.check_type(the_body, truth_value)
    if the_body.is_a?(Hash)
      case the_body.dig("topic")
      when "buygoods_transaction_received"
        puts "Buy Goods Transaction Received."
        test_bg = BuyGoods.new(truth_value)
        test_bg.components the_body
        K2Split.return_hash(test_bg)
      when "buygoods_transaction_reversed"
        puts "Buy Goods Transaction Reversed."
        K2Split.return_hash(Reversal.new(truth_value).components(the_body))
      when "settlement_transfer_completed"
        puts "Settlement Transaction."
        K2Split.return_hash( Settlement.new(truth_value).components(the_body))
      when "customer_created"
        puts "Customer Created."
        K2Split.return_hash(CustomerCreated.new(truth_value).components(the_body))
      when "payment_request"
        puts "STK Push Payment Request Result."
        K2Split.return_hash(K2ProcessStk.new(truth_value).components(the_body))
      else
        unless the_body.empty?
          K2Split.return_hash(K2ProcessPay.new(truth_value).components(the_body))
        end
        raise K2UnspecifiedEvent.new
      end
    else
      raise K2InvalidBody
    end
  rescue K2InvalidBody => k2
    return false
  rescue K2UnspecifiedEvent => k3
    return false
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