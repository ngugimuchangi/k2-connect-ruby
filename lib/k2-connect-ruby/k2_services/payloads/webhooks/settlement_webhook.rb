class SettlementWebhook < K2CommonEvents
  attr_reader :disbursements,
              :destination_type,
              :destination_network,
              :destination_reference,
              :destination_last_name,
              :destination_first_name,
              :destination_account_name,
              :destination_phone_number,
              :destination_account_number,
              :destination_bank_branch_ref,
              :destination_settlement_method

  def initialize(payload)
    super
    # Destination
    @disbursements = payload.dig('event', 'resource', 'disbursements')
    @destination_type = payload.dig('event', 'resource', 'destination', 'type')
    @destination_reference = payload.dig('event', 'resource', 'destination', 'resource', 'reference')
    destination_assets(payload)
  end

  def destination_assets(payload)
    if @destination_type.eql?('Mobile Wallet')
      @destination_network = payload.dig('event', 'resource', 'destination', 'resource', 'network')
      @destination_last_name = payload.dig('event', 'resource', 'destination', 'resource', 'last_name')
      @destination_first_name = payload.dig('event', 'resource', 'destination', 'resource', 'first_name')
      @destination_phone_number = payload.dig('event', 'resource', 'destination', 'resource', 'phone_number')
    elsif @destination_type.eql?('Bank Account')
      @destination_account_name = payload.dig('event', 'resource', 'destination', 'resource', 'account_name')
      @destination_account_number = payload.dig('event', 'resource', 'destination', 'resource', 'account_number')
      @destination_bank_branch_ref = payload.dig('event', 'resource', 'destination', 'resource', 'bank_branch_ref')
      @destination_settlement_method = payload.dig('event', 'resource', 'destination', 'resource', 'settlement_method')
    end
  end
end