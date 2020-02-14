class MerchantToMerchant < K2CommonEvents
  attr_reader :resource_sending_merchant

  def initialize(payload)
    super
    @resource_sending_merchant = payload.dig('event', 'resource', 'sending_merchant')
  end
end