class K2Transfer < K2Entity
  # Create a Verified Settlement Account via API
  def settlement_account(transfer_params)
    # Validation
    validate_input(transfer_params) and return

    # The Request Body Parameters
    settlement_body = {
        account_name: transfer_params["account_name"],
        bank_ref: transfer_params["bank_ref"],
        bank_branch_ref: transfer_params["bank_branch_ref"],
        account_number: transfer_params["account_number"]
    }
    settlement_hash = {
        :path_url => "merchant_bank_accounts",
        :access_token =>  @k2_access_token,
        :is_get_request => false,
        :is_subscription => false,
        :params => settlement_body
    }
    K2Connect.to_connect(settlement_hash)
  rescue StandardError => e
    puts(e.message)
    return false
  end

  # Create a either a 'blind' transfer, for when destination is specified, and a 'targeted' transfer which has a specified destination.
  def transfer_funds(destination, transfer_params)
    # Validation
    validate_input(transfer_params) and return
    # The Request Body Parameters
    if destination.nil?
      # Blind Transfer
      transfer_body = {
          amount: {
              currency: transfer_params["currency"],
              value: transfer_params["value"]
          }
      }
    else
      # Targeted Transfer
      transfer_body = {
          amount: {
              currency: transfer_params["currency"],
              value: transfer_params["value"]
          },
          destination: destination
      }
    end
    transfer_hash = {
        :path_url => "transfers",
        :access_token =>  @k2_access_token,
        :is_get_request => false,
        :is_subscription => false,
        :params => transfer_body
    }
    K2Connect.to_connect(transfer_hash)
  end

  # Check the status of a prior initiated Transfer. Make sure to add the id to the url
  def query_transfer(id)
    # Validation
    validate_input(id) and return

    query_body = {
        ID: id
    }
    query_transfer_hash = {
        :path_url => "transfers",
        :access_token =>  @k2_access_token,
        :is_get_request => true,
        :is_subscription => false,
        :params => query_body
    }
    K2Connect.to_connect(query_transfer_hash)
  end
end