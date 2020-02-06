# For Transferring funds to pre-approved and owned settlement accounts
# TODO: Not added to the K2 API, together with the post requests not completing its location url
class K2Transfer < K2Entity
  attr_reader :settlement_location_url, :transfer_location_url

  # Create a Verified Settlement Account via API (Mobile Wallet and Bank Account)
  def settlement_account(params)
    params=params.with_indifferent_access
    the_path_url = ''
    settlement_body = {}
    @exception_array += %w[type]
    # The Request Body Parameters
    if params[:type].eql?('mobile_wallet')
      params = validate_input(params, @exception_array += %w[msisdn network])
      settlement_body = {
          msisdn: validate_phone(params[:msisdn]),
          network: params[:network]
      }
      the_path_url = 'api/v1/merchant_wallets'
    elsif params[:type].eql?('bank_account')
      params = validate_input(params, @exception_array += %w[account_name bank_id bank_branch_id account_number currency value])
      settlement_body = {
          account_name: params[:account_name],
          bank_id: params[:bank_id],
          bank_branch_id: params[:bank_branch_id],
          account_number: params[:account_number]
      }
      the_path_url = 'api/v1/merchant_bank_accounts'
    end

    settlement_hash = K2Transfer.make_hash(the_path_url, 'POST', @access_token, 'Transfer', settlement_body)
    @threads << Thread.new do
      sleep 0.25
      @settlement_location_url = K2Connect.connect(settlement_hash)
    end
    @threads.each(&:join)
  end

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
    transfer_hash = K2Transfer.make_hash('api/v1/transfers', 'POST', @access_token, 'Transfer', transfer_body)
    @threads << Thread.new do
      sleep 0.25
      @transfer_location_url = K2Connect.connect(transfer_hash)
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
