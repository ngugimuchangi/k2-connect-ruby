require 'k2-connect-ruby/k2_services/k2_client'

require 'k2-connect-ruby/k2_services/payloads/k2_webhooks'
require 'k2-connect-ruby/k2_services/payloads/webhooks/b2b_transaction_received'
require 'k2-connect-ruby/k2_services/payloads/webhooks/customer_created'
require 'k2-connect-ruby/k2_services/payloads/webhooks/buygoods_transaction_received'
require 'k2-connect-ruby/k2_services/payloads/webhooks/buygoods_transaction_reversed'
require 'k2-connect-ruby/k2_services/payloads/webhooks/settlement_webhook'

require 'k2-connect-ruby/k2_services/payloads/k2_transaction'
require 'k2-connect-ruby/k2_services/payloads/transactions/transfer'
require 'k2-connect-ruby/k2_services/payloads/transactions/incoming_payment'
require 'k2-connect-ruby/k2_services/payloads/transactions/outgoing_payment'

module K2ConnectRuby
  module K2Services
    module PayloadProcess; end
  end
end
