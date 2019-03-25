# Module for Splitting the Response to simple components.
module K2ProcessResult
  # Confirm Truth value and carry out splitting.
  def self.process(the_body)
    raise ArgumentError, 'Empty/Nil Request Body Argument!' if the_body.blank?

    K2ProcessResult.check_topic(the_body)
  end

  # Check the Event Type.
  def self.check_topic(the_body)
    body_topic = the_body.dig('topic')
    if body_topic.eql?('transaction_received')
      event_type = the_body.dig('event', 'type')

      case event_type
      # Buygoods Transaction Received
      when 'Buygoods Transaction'
        buy_goods = BuyGoods.new
        buy_goods.components(the_body)
        return buy_goods

      # External till to till Transaction Received
      when 'B2b Transaction'
        buy_goods = B2B.new
        buy_goods.components(the_body)
        return buy_goods

      # Merchant to Merchant Account Transaction Received
      when 'Merchant to Merchant Transaction'
        buy_goods = MerchantTransaction.new
        buy_goods.components(the_body)
        return buy_goods
      else
        raise ArgumentError, 'No Other Specified Event!'
      end

    else

      case body_topic
      # Buy Goods Transaction Reversal
      when 'buygoods_transaction_reversed'
        reversals = Reversal.new
        reversals.components(the_body)
        return reversals

      # Settlement Transfer Completed
      when 'settlement_transfer_completed'
        settlement = Settlement.new
        settlement.components(the_body)
        return settlement

      # Customer Created
      when 'customer_created'
        customer = CustomerCreated.new
        customer.components(the_body)
        return customer

      # STK Process Payment Request Result
      when 'payment_request'
        status = the_body.dig('status')
        if status.eql?('Success')
          stk_result = K2ProcessStk.new
          stk_result.components(the_body)
          return stk_result
        elsif status.eql?('Failed')
          stk_result = K2FailedStk.new
          stk_result.components(the_body)
          return stk_result
        end

      # PAY Process Payment Result
      when 'pay_request'
        pay_result = K2ProcessPay.new
        pay_result.components(the_body)
        return pay_result

        # For Query Results
      else
        raise ArgumentError, 'No Other Specified Event!'
      end
    end
  end

  # Returns a Hash Object
  def self.return_obj_hash(instance_hash = HashWithIndifferentAccess.new, obj)
    obj.instance_variables.each do |value|
      instance_hash[:"#{value.to_s.tr('@', '')}"] = obj.instance_variable_get(value)
    end
    instance_hash.each(&:freeze).freeze
  end

  # Returns an Array Object
  def self.return_obj_array(instance_array = [], obj)
    obj.instance_variables.each do |value|
      instance_array << obj.instance_variable_get(value)
    end
    instance_array.each(&:freeze).freeze
  end
end
