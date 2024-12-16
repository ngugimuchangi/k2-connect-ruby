module K2ConnectRuby
  module K2Entity
    class K2Pay < K2ConnectRuby::K2Entity::K2Entity
      attr_reader :recipients_location_url, :payments_location_url

      # Adding PAY Recipients with either mobile_wallets or bank_accounts as destination of your payments.
      def add_recipient(params)
        params = params.with_indifferent_access
        @exception_array += %w[type]
        # In the case of mobile pay recipient
        k2_request_pay_recipient = if params[:type].eql?('mobile_wallet')
                                     params = validate_input(params, @exception_array += %w[first_name last_name phone_number email network])
                                     {
                                       first_name: params[:first_name],
                                       last_name: params[:last_name],
                                       phone_number: validate_phone(params[:phone_number]),
                                       email: validate_email(params[:email]),
                                       network: params[:network]
                                     }
                                     # In the case of bank pay recipient
                                   elsif params[:type].eql?('bank_account')
                                     params = validate_input(params, @exception_array += %w[account_name account_number bank_branch_ref settlement_method])
                                     {
                                       account_name: params[:account_name],
                                       account_number: params[:account_number],
                                       bank_branch_ref: params[:bank_branch_ref],
                                       settlement_method: params[:settlement_method]
                                     }
                                     # In the case of till pay recipient
                                   elsif params[:type].eql?('till')
                                     params = validate_input(params, @exception_array += %w[till_name till_number])
                                     {
                                       till_name: params[:till_name],
                                       till_number: params[:till_number]
                                     }
                                     # In the case of bank pay recipient
                                   elsif params[:type].eql?('paybill')
                                     params = validate_input(params, @exception_array += %w[paybill_name paybill_number paybill_account_number])
                                     {
                                       paybill_name: params[:paybill_name],
                                       paybill_number: params[:paybill_number],
                                       paybill_account_number: params[:paybill_account_number]
                                     }
                                   else
                                     raise ArgumentError, 'Undefined Payment Method.'
                                   end
        recipients_body = {
          type: params[:type],
          #type: params['pay_type'],
          pay_recipient: k2_request_pay_recipient
        }
        pay_recipient_hash = make_hash(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('pay_recipient'), 'post', @access_token, 'PAY', recipients_body)
        @recipients_location_url = K2ConnectRuby::K2Utilities::K2Connection.make_request(pay_recipient_hash)
      end

      # Create an outgoing Payment to a third party.
      def create_payment(params)
        # Validation
        params = validate_input(params, @exception_array += %w[destination_reference destination_type description category tags currency value callback_url metadata])
        # The Request Body Parameters
        k2_request_pay_amount = {
          currency: params[:currency],
          value: params[:value]
        }
        k2_request_pay_metadata = params[:metadata]
        k2_request_links = {
          callback_url: params[:callback_url]
        }
        create_payment_body = {
          destination_reference: params[:destination_reference],
          destination_type: params[:destination_type],
          description: params[:description],
          category: params[:category],
          tags: params[:tags],
          amount: k2_request_pay_amount,
          meta_data: k2_request_pay_metadata,
          _links: k2_request_links
        }
        create_payment_hash = make_hash(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('payments'), 'post', @access_token, 'PAY', create_payment_body)
        @payments_location_url = K2ConnectRuby::K2Utilities::K2Connection.make_request(create_payment_hash)
      end

      # Query/Check the status of a previously initiated PAY Payment request
      def query_status(method_type)
        if method_type.eql?('recipients')
          super('PAY', @recipients_location_url)
        elsif method_type.eql?('payments')
          super('PAY', @payments_location_url)
        end
      end

      # Query Location URL
      def query_resource(url)
        super('PAY', url)
      end
    end
  end
end
