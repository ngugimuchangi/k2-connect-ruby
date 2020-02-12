class CustomerCreated < Webhook
  attr_reader :resource_first_name,
              :resource_middle_name,
              :resource_last_name,
              :resource_msisdn

  def self.new(payload)
    super
    @resource_first_name = payload.dig('resource', 'first_name')
    @resource_middle_name = payload.dig('resource', 'middle_name')
    @resource_last_name = payload.dig('resource', 'last_name')
    @resource_msisdn = payload.dig('resource', 'msisdn')
  end
end