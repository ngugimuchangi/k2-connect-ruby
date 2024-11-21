module K2ConnectRuby
  module K2Entity
    class K2Stk < K2ConnectRuby::K2Entity::K2Entity
      # Receive payments from M-PESA users.
      def receive_mpesa_payments(params)
        # Validation
        params = validate_input(params, @exception_array += %w[payment_channel till_number first_name last_name phone_number email currency value metadata callback_url])
        # The Request Body Parameters
        k2_request_subscriber = {
          first_name: params[:first_name],
          middle_name: params[:middle_name],
          last_name: params[:last_name],
          phone_number: validate_phone(params[:phone_number]),
          email: validate_email(params[:email])
        }
        k2_request_amount = {
          currency: 'KES',
          value: params[:value]
        }
        k2_request_metadata = params[:metadata]
        k2_request_links = {
          callback_url: params[:callback_url]
        }
        receive_body = {
          payment_channel: params[:payment_channel],
          till_number: validate_till_number_prefix(params[:till_number]),
          subscriber: k2_request_subscriber,
          amount: k2_request_amount,
          meta_data: k2_request_metadata,
          _links: k2_request_links
        }
        receive_hash = make_hash(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('incoming_payments'), 'post', @access_token, 'STK', receive_body)
        @location_url = K2ConnectRuby::K2Utilities::K2Connection.make_request(receive_hash)
      end

      # Query/Check STK Payment Request Status
      def query_status
        super('STK', path_url=@location_url)
      end

      # Query Location URL
      def query_resource(url)
        super('STK', url)
      end
    end
  end
end
