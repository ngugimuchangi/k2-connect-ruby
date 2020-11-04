class SettlementWebhook < K2CommonEvents
  attr_reader :destination_type,
              :destination_network,
              :destination_reference,
              :destination_last_name,
              :destination_first_name,
              :destination_account_name,
              :destination_phone_number,
              :destination_account_number,
              :destination_bank_branch_ref

  def initialize(payload)
    super
    # Destination
    @destination_type = payload.dig('event', 'resource', 'destination', 'type')
    destination_assets(payload)
  end

  def destination_assets(payload)
    if @destination_type.eql?('merchant_wallet')
      @destination_network = payload.dig('event', 'resource', 'destination', 'resource', 'network')
      @destination_reference = payload.dig('event', 'resource', 'destination', 'resource', 'reference')
      @destination_last_name = payload.dig('event', 'resource', 'destination', 'resource', 'last_name')
      @destination_first_name = payload.dig('event', 'resource', 'destination', 'resource', 'first_name')
      @destination_phone_number = payload.dig('event', 'resource', 'destination', 'resource', 'phone_number')
    elsif @destination_type.eql?('merchant_bank_account')
      @destination_account_name = payload.dig('event', 'resource', 'destination', 'resource', 'account_name')
      @destination_account_number = payload.dig('event', 'resource', 'destination', 'resource', 'account_number')
      @destination_bank_branch_ref = payload.dig('event', 'resource', 'destination', 'resource', 'bank_branch_ref')
    end
  end
end