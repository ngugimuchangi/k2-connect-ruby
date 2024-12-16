module K2ConnectRuby
  module K2Services
    module Payloads
      module Transactions
        class Transfer < OutgoingTransaction

          def initialize(payload)
            super
          end

          private

          def valid_payment_type
            raise ArgumentError, "Wrong Payment Type" unless @type.eql?("settlement_transfer")
          end
        end
      end
    end
  end
end
