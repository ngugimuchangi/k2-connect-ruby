# Processes Webhook
module K2ProcessWebhook
  def self.process(payload, secret_key, signature)
    raise ArgumentError, 'Empty/Nil Request Body Argument!' if payload.blank?
    self.check_topic(payload) if K2Authenticator.authenticate(payload, secret_key, signature)
  end

  def self.check_topic(payload)
    result_topic = payload.dig('topic')
    case result_topic
      # Buygoods Transaction Received
    when 'buygoods_transaction_received'
      buygoods_received = BuygoodsTransactionReceived.new(payload)
      return buygoods_received
      # Buygoods Transaction Reversed
    when 'buygoods_transaction_reversed'
      buygoods_reversed = BuygoodsTransactionReversed.new(payload)
      return buygoods_reversed
      # B2b Transaction
    when 'b2b_transaction_received'
      b2b_transaction = B2b.new(payload)
      return b2b_transaction
      # Merchant to Merchant
    when 'm2m_transaction_received'
      m2m_transaction_received = MerchantToMerchant.new(payload)
      return m2m_transaction_received
      # Settlement Transfer
    when 'settlement_transfer_completed'
      settlement_transfer = SettlementWebhook.new(payload)
      return settlement_transfer
      # Customer Created
    when 'customer_created'
      customer_created = CustomerCreated.new(payload)
      return customer_created
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