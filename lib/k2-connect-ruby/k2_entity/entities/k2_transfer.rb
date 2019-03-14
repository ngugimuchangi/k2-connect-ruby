# For Transferring funds to pre-approved and owned settlement accounts
class K2Transfer < K2Entity
  include K2Validation

  # Create a Verified Settlement Account via API
  def settlement_account(params)
    # Validation
    params = validate_input(params, @exception_array += %w[account_name bank_ref bank_branch_ref account_number currency value])
    # The Request Body Parameters
    settlement_body = {
        account_name: params['account_name'],
        bank_ref: params['bank_ref'],
        bank_branch_ref: params['bank_branch_ref'],
        account_number: params['account_number']
    }
    settlement_hash = K2Transfer.make_hash('merchant_bank_accounts', 'POST', @access_token, 'Transfer', settlement_body)
    @threads << Thread.new do
      sleep 0.25
      @location_url = K2Connect.to_connect(settlement_hash)
    end
    @threads.each(&:join)
  end

  # Create a either a 'blind' transfer, for when destination is specified, and a 'targeted' transfer which has a specified destination.
  def transfer_funds(destination, params)
    # Validation
    params = validate_input(params, @exception_array += %w[currency value])
    # The Request Body Parameters
    if destination.blank?
      # Blind Transfer
      transfer_body = {
          amount: {
              currency: params['currency'],
              value: params['value']
          }
      }
    else
      # Targeted Transfer
      transfer_body = {
          amount: {
              currency: params['currency'],
              value: params['value']
          },
          destination: destination
      }
    end
    transfer_hash = K2Transfer.make_hash('transfers', 'POST', @access_token, 'Transfer', transfer_body)
    @threads << Thread.new do
      sleep 0.25
      @location_url = K2Connect.to_connect(transfer_hash)
    end
    @threads.each(&:join)
  end

  # Check the status of a prior initiated Transfer. Make sure to add the id to the url
  def query_status(params, path_url = 'transfers', class_type = 'Transfer')
    super
  end
end
