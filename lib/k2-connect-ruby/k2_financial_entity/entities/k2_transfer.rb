# For Transferring funds to pre-approved and owned settlement accounts
class K2Transfer < K2Entity
  # Create a either a 'blind' transfer, for when destination is specified, and a 'targeted' transfer which has a specified destination.
  def transfer_funds(destination, params)
    # Validation
    params = validate_input(params, @exception_array += %w[currency value callback_url])
    # The Request Body Parameters
    k2_request_transfer = if destination.blank?
                      # Blind Transfer
                      {
                        amount: {
                          currency: params[:currency],
                          value: params[:value]
                        },
                        destination: nil
                      }
                    else
                      # Targeted Transfer
                      {
                        amount: {
                          currency: params[:currency],
                          value: params[:value]
                        },
                        destination: destination
                      }
                          end
    metadata = {
        something: "Nice",
        extra: "Comments"
    }
    transfer_body = k2_request_transfer.merge(
        {
            _links:
                {
                    callback_url: params[:callback_url]
                },
            meta_data: metadata
        })
    transfer_hash = K2Transfer.make_hash(K2Config.path_variable('transfers'), 'POST', @access_token, 'Transfer', transfer_body)
    @threads << Thread.new do
      sleep 0.25
      @location_url = K2Connect.connect(transfer_hash)
    end
    @threads.each(&:join)
  end

  # Check the status of a prior initiated Transfer. Make sure to add the id to the url
  def query_status(path_url)
    super('Transfer', path_url)
  end

  # Query Location URL
  def query_resource_url(url)
    super('Transfer', url)
  end
end
