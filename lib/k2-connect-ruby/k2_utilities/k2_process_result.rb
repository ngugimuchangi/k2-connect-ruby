module K2ConnectRuby
  module K2Utilities
    module K2ProcessResult
      extend self

      def process(payload, secret_key, signature)
        raise ArgumentError, 'Empty/Nil Request Body Argument!' if payload.blank?
        check_type(payload) if K2ConnectRuby::K2Utilities::K2Authenticator.authenticate(payload, secret_key, signature)
      end

      # Check the Event Type.
      def check_type(payload)
        result_type = payload.dig('data', 'type')
        case result_type
          # Incoming Payments
        when 'incoming_payment'
          incoming_payments = K2ConnectRuby::K2Services::Payloads::Transactions::IncomingPayment.new(payload)
          return incoming_payments
          # Outgoing Payments
        when 'payment'
          outgoing_payments = K2ConnectRuby::K2Services::Payloads::Transactions::OutgoingPayment.new(payload)
          return outgoing_payments
        when 'settlement_transfer'
          transfer = K2ConnectRuby::K2Services::Payloads::Transactions::Transfer.new(payload)
          return transfer
        else
          raise ArgumentError, 'No Other Specified Payment Type!'
        end
      end

      # Returns a Hash Object
      def return_obj_hash(instance_hash = HashWithIndifferentAccess.new, obj)
        obj.instance_variables.each do |value|
          instance_hash[:"#{value.to_s.tr('@', '')}"] = obj.instance_variable_get(value)
        end
        instance_hash.each(&:freeze).freeze
      end

      # Returns an Array Object
      def return_obj_array(instance_array = [], obj)
        obj.instance_variables.each do |value|
          instance_array << obj.instance_variable_get(value)
        end
        instance_array.each(&:freeze).freeze
      end
    end
  end
end
