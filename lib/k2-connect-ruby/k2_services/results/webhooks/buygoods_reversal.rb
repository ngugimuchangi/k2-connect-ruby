class BuygoodsTransactionReversed < Buygoods
  attr_reader :resource_reversal_time

  def self.new(payload)
    super
    @resource_reversal_time = payload.dig('event', 'resource', 'reversal_time')
  end
end