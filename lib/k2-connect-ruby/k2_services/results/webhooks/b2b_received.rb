class B2b < K2CommonEvents
  attr_reader :resource_sending_till

  def initialize(payload)
    super
    @resource_sending_till = payload.dig('event', 'resource', 'sending_till')
  end
end