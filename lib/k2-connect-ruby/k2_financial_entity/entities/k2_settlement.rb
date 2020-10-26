# For Creating pre-approved and owned settlement accounts
class K2Settlement < K2Entity
  # Create a Verified Settlement Account via API (Mobile Wallet and Bank Account)
  def add_settlement_account(params)
    params=params.with_indifferent_access
    the_path_url = ''
    settlement_body = {}
    @exception_array += %w[type]
    # The Request Body Parameters
    if params[:type].eql?('merchant_wallet')
      params = validate_input(params, @exception_array += %w[phone_number network])
      settlement_body = {
        phone_number: validate_phone(params[:phone_number]),
        network: params[:network]
      }
      the_path_url = K2Config.path_url('settlement_mobile_wallet')
    elsif params[:type].eql?('merchant_bank_account')
      params = validate_input(params, @exception_array += %w[account_name bank_id bank_branch_id account_number currency value])
      settlement_body = {
          account_name: params[:account_name],
          bank_id: params[:bank_id],
          bank_branch_id: params[:bank_branch_id],
          account_number: params[:account_number]
      }
      the_path_url = K2Config.path_url('settlement_bank_account')
    else
      raise ArgumentError, 'Unknown Settlement Account'
    end

    settlement_hash = make_hash(the_path_url, 'post', @access_token, 'Transfer', settlement_body)
    @threads << Thread.new do
      sleep 0.25
      @location_url = K2Connect.make_request(settlement_hash)
    end
    @threads.each(&:join)
  end

  # Check the status of a prior initiated Transfer. Make sure to add the id to the url
  def query_status
    super('Settlement', path_url=@location_url)
  end

  # Query Location URL
  def query_resource(url)
    super('Settlement', url)
  end
end