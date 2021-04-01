class B2b < K2CommonEvents
  attr_reader :sending_till,
              :till_number

  def initialize(payload)
    super
    @till_number = payload.dig('event', 'resource', 'till_number')
    @sending_till = payload.dig('event', 'resource', 'sending_till')
  end
end