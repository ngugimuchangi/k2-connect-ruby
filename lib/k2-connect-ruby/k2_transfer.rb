class K2Transfer
  attr_accessor :k2_response_transfer,
                :k2_access_token

  def initialize(access_token)
    @k2_access_token = access_token
  end

  # Create a Verified Settlement Account via API
  def settlement_account(transfer_params)
    # The Request Body Parameters
    settlement_body = {
        account_name: transfer_params["account_name"],
        bank_ref: transfer_params["bank_ref"],
        bank_branch_ref: transfer_params["bank_branch_ref"],
        account_number: transfer_params["account_number"]
    }.to_json
    K2ConnectRuby.to_connect(settlement_body, "merchant_bank_accounts", @k2_access_token, false, false)
  rescue StandardError => e
    puts(e.message)
    return false
  end

  # Create a either a 'blind' transfer, for when destination is specified, and a 'targeted' transfer which has a specified destination.
  def transfer_funds(destination, transfer_params)
    # The Request Body Parameters
    if destination.nil?
      # Blind Transfer
      transfer_body = {
          amount: {
              currency: transfer_params["currency"],
              value: transfer_params["value"]
          }
      }.to_json
    else
      # Targeted Transfer
      transfer_body = {
          amount: {
              currency: transfer_params["currency"],
              value: transfer_params["value"]
          },
          destination: destination
      }.to_json
    end
    K2ConnectRuby.to_connect(transfer_body, "transfers", @k2_access_token, false, false)
  end

  # Check the status of a prior initiated Transfer.
  def query_transfer(id)
    query_body = {
        ID: id
    }.to_json
    K2ConnectRuby.to_connect(query_body, "transfers", @k2_access_token, false, true)
  end
end