class B2b < K2CommonEvents
  attr_reader :sending_till

  def initialize(payload)
    super
    @sending_till = payload.dig('event', 'resource', 'sending_till')
  end
end