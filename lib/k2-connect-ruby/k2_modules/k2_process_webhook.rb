# Processes Webhook
module K2ProcessWebhook
  def self.process(payload)
    raise ArgumentError, 'Empty/Nil Request Body Argument!' if payload.blank?
    self.check_topic(payload)
  end

  def self.check_topic(payload)
    result_topic = payload.dig('topic')
    case result_topic
      # Buygoods Transaction Received
    when 'buygoods_transaction_received'
      return BuygoodsTransactionReceived.new.components(payload)
      # Buygoods Transaction Reversed
    when 'buygoods_transaction_reversed'
      return BuygoodsTransactionReversed.new.components(payload)
      # B2b Transaction
    when 'b2b_transaction'
      return B2b.new.components(payload)
      # Merchant to Merchant
    when 'merchant_to_merchant'
      return MerchantToMerchant.new.components(payload)
      # Settlement Transfer
    when 'settlement_transfer_completed'
      return Settlements.new.components(payload)
      # Customer Created
    when 'customer_created'
      return CustomerCreated.new.components(payload)
    else
      raise ArgumentError, 'No Other Specified Event!'
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