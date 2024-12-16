module K2ConnectRuby
  module K2Utilities
    module K2Validation
      ALL_EVENT_TYPES = %[buygoods_transaction_received b2b_transaction_received buygoods_transaction_reversed customer_created settlement_transfer_completed]
      TILL_SCOPE_EVENT_TYPES = %[buygoods_transaction_received b2b_transaction_received buygoods_transaction_reversed]

      # Validating Method
      def validate_input(the_input, the_array)
        if the_input.blank?
          raise ArgumentError, "Empty or Nil Input!\n No Input Content has been given."
        else
          unless !!the_input == the_input
            if the_input.is_a?(Hash)
              validate_hash(the_input.with_indifferent_access, the_array)
            else
              begin
                if the_input.is_a?(String)
                  raise ArgumentError, "Wrong Input Format.\n The Input is a String."
                elsif the_input.is_a?(Integer)
                  raise ArgumentError, "Wrong Input Format.\n The Input is an Integer."
                elsif the_input.key?(:authenticity_token)
                  nil_values(the_input.permit(the_array).to_hash.with_indifferent_access)
                else
                  raise ArgumentError, "Undefined Input Format.\n The Input is Neither a Hash nor an ActionController::Parameter Object."
                end
              rescue NoMethodError => nme
                if nme.message.include?('has_key?')
                  raise ArgumentError, "Undefined Input Format.\n The Input is Neither a Hash nor an ActionController::Parameter Object."
                end
              end
            end
          end
        end
        to_indifferent_access(the_input)
      end

      # Validate the Hash Input Parameters
      def validate_hash(the_input, the_array)
        nil_values(the_input)
        incorrect_keys(the_input, the_array)
      end

      # Return Incorrect Key Symbols for Hashes
      def incorrect_keys(the_input, invalid_hash = [], the_array)
        the_input.each_key do |key|
          validate_network(the_input[:network]) if key.eql?("network")
          validate_settlement_method(the_input[:settlement_method]) if key.eql?("settlement_method")
          invalid_hash << key unless the_array.include?(key.to_s)
        end
        raise K2IncorrectParams, invalid_hash if invalid_hash.present?
      end

      # Return Key Symbols with Blank Values
      def nil_values(the_input, nil_keys_array = [])
        the_input.select { |_, v| v.blank? }.each_key do |key|
          nil_keys_array << key.to_s
        end
        raise K2EmptyParams, nil_keys_array unless nil_keys_array.blank?
      end

      # Validate Phone Number
      def validate_phone(phone)
        raise ArgumentError, "No Phone Number given." if phone.blank?
        # Kenyan Phone Numbers
        unless phone.blank?
          if phone[-(number = phone.to_i.to_s.size).to_i, 3].eql?(254.to_s)
            raise ArgumentError, 'Invalid Kenyan Phone Number.' unless phone[-9, 9][0].eql?(7.to_s)
          else
            raise ArgumentError, 'Invalid Phone Number.' unless number.eql?(9)
          end
          phone.tr('+', '')
        end
      end

      # Validate Email Format
      def validate_email(email)
        unless email.blank?
          raise ArgumentError, 'Invalid Email Address.' unless email.match(URI::MailTo::EMAIL_REGEXP).present?
        end
        email
      end

      # Validate the Network Operator
      def validate_network(network)
        raise ArgumentError, "Invalid Network Operator." unless K2ConnectRuby::K2Utilities::Config::K2Config.network_operators.include?(network.to_s.upcase)
      end

      def validate_settlement_method(settlement_method)
        raise ArgumentError, "Wrong Settlement Method" unless settlement_method.eql?("EFT") || settlement_method.eql?("RTS")
      end

      # Converts Hash Objects to HashWithIndifferentAccess Objects
      def to_indifferent_access(params)
        params.with_indifferent_access
      end

      def validate_url(url)
        raise ArgumentError, 'Invalid URL Format.' unless url =~ /\A#{URI.regexp(%w[https http])}\z/
        url
      end

      def validate_till_number_prefix(till_number)
        raise ArgumentError, "No Till Number given." if till_number.blank?
        raise ArgumentError, "Invalid Till Number format." unless till_number[0, 1].eql?('K')
        till_number
      end

      def validate_webhook(params)
        raise ArgumentError, 'Subscription Service does not Exist!' unless params[:event_type].in?(ALL_EVENT_TYPES)
        determine_scope_details(params)
      end

      def validate_webhook_input(params)
        if params[:event_type].in?(TILL_SCOPE_EVENT_TYPES)
          validate_input(params, %w[event_type scope scope_reference url])
        else
          validate_input(params.except(:scope_reference), %w[event_type scope url])
        end
      end

      def determine_scope_details(params)
        if params[:scope].eql?('till')
          raise ArgumentError, "Invalid scope till for the event type" unless params[:event_type].in?(TILL_SCOPE_EVENT_TYPES)
        end
      end
    end
  end
end
