class CustomerCreated < Webhook
  attr_reader :resource_first_name,
              :resource_middle_name,
              :resource_last_name,
              :resource_phone_number

  def initialize(payload)
    super
    @resource_first_name = payload.dig('event', 'resource', 'first_name')
    @resource_middle_name = payload.dig('event', 'resource', 'middle_name')
    @resource_last_name = payload.dig('event', 'resource', 'last_name')
    @resource_phone_number = payload.dig('event', 'resource', 'phone_number')
  end
end