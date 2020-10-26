class SettlementWebhook < K2CommonEvents
  attr_reader :destination_type,
              :destination_msisdn,
              :destination_network,
              :destination_bank_id,
              :destination_account_name,
              :destination_account_number,
              :destination_bank_branch_id

  def initialize(payload)
    super
    # Destination
    @destination_type = payload.dig('event', 'resource', 'destination', 'type')
    destination_assets(payload)
  end

  def destination_assets(payload)
    if @destination_type.eql?('merchant_wallet')
      puts "Merchant Wallet"
      @destination_msisdn = payload.dig('event', 'resource', 'destination', 'resource', 'msisdn')
      @destination_network = payload.dig('event', 'resource', 'destination', 'resource', 'network')
    elsif @destination_type.eql?('merchant_bank_account')
      puts "Merchant Bank Account"
      @destination_bank_id = payload.dig('event', 'resource', 'destination', 'resource', 'bank_id')
      @destination_bank_branch_id = payload.dig('event', 'resource', 'destination', 'resource', 'bank_branch_id')
      @destination_account_name = payload.dig('event', 'resource', 'destination', 'resource', 'account_name')
      @destination_account_number = payload.dig('event', 'resource', 'destination', 'resource', 'account_number')
    end
  end
end