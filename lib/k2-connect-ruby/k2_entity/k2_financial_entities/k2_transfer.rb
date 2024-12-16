module K2ConnectRuby
  module K2Entity
    class K2Transfer < K2ConnectRuby::K2Entity::K2Entity
      # Create a either a 'blind' transfer, for when destination is specified, and a 'targeted' transfer which has a specified destination.
      def transfer_funds(params)
        # Validation
        unless params["destination_reference"].blank? && params["destination_type"].blank?
          params = validate_input(params, @exception_array += %w[destination_reference destination_type callback_url metadata])
        end
        params = params.with_indifferent_access
        # The Request Body Parameters
        k2_request_transfer = {
          destination_reference: params[:destination_reference],
          destination_type: params[:destination_type],
          amount: {
            currency: params[:currency],
            value: params[:value]
          }
        }
        metadata = params[:metadata]
        transfer_body = k2_request_transfer.merge(
          {
            _links:
              {
                callback_url: params[:callback_url]
              },
            metadata: metadata
          })
        transfer_hash = make_hash(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('transfers'), 'post', @access_token, 'Transfer', transfer_body)
        @location_url = K2ConnectRuby::K2Utilities::K2Connection.make_request(transfer_hash)
      end

      # Check the status of a prior initiated Transfer. Make sure to add the id to the url
      def query_status
        super('Transfer', path_url=@location_url)
      end

      # Query Location URL
      def query_resource(url)
        super('Transfer', url)
      end
    end
  end
end
