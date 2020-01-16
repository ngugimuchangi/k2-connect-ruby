# For Transferring funds to pre-approved and owned settlement accounts
# TODO: Not added to the K2 API, together with the post requests not completing its location url
class K2Transfer < K2Entity

  # Create a Verified Settlement Account via API
  def settlement_account(params)
    # Validation
    params = validate_input(params, @exception_array += %w[account_name bank_ref bank_branch_ref account_number currency value])
    # The Request Body Parameters
    settlement_body = {
      account_name: params[:account_name],
      bank_ref: params[:bank_ref],
      bank_branch_ref: params[:bank_branch_ref],
      account_number: params[:account_number]
    }
    settlement_hash = K2Transfer.make_hash('api/v1/merchant_bank_accounts', 'POST', @access_token, 'Transfer', settlement_body)
    @threads << Thread.new do
      sleep 0.25
      @location_url = K2Connect.connect(settlement_hash)
    end
    @threads.each(&:join)
  end

  # Create a either a 'blind' transfer, for when destination is specified, and a 'targeted' transfer which has a specified destination.
  def transfer_funds(destination, params)
    # Validation
    params = validate_input(params, @exception_array += %w[currency value])
    # The Request Body Parameters
    transfer_body = if destination.blank?
                      # Blind Transfer
                      {
                        amount: {
                          currency: params[:currency],
                          value: params[:value]
                        }
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
    transfer_hash = K2Transfer.make_hash('api/v1/transfers', 'POST', @access_token, 'Transfer', transfer_body)
    @threads << Thread.new do
      sleep 0.25
      @location_url = K2Connect.connect(transfer_hash)
    end
    @threads.each(&:join)
  end

  # Check the status of a prior initiated Transfer. Make sure to add the id to the url
  def query_status(path_url = @location_url)
    super('Transfer')
  end
end
