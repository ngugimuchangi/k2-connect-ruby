module K2ConnectRuby
  class K2Transfer
    attr_accessor :k2_response_transfer

    # https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io mock server
    # def initialize(postman_mock_server)
    #   @postman_mock_server = postman_mock_server
    # end

    # Sets the Url for the mock server / API server
    def set_k2_mocks
      @postman_k2_mock_server = "https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io"
    end

    # Create a Verified Settlement Account via API
    def settlement_account(account_name, bank_ref, bank_branch_ref, account_number)
      set_k2_mocks
      k2_url = URI.parse("#{@postman_k2_mock_server}/merchant_bank_accounts")
      k2_https = Net::HTTP.new(k2_url.host, k2_url.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Post.new(k2_url)
      k2_request.add_field('Content-Type', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Accept', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Authorization', "Bearer access_token")

      k2_request.body = {
          "account_name": "#{account_name}",
          "bank_ref": "#{bank_ref}",
          "bank_branch_ref": "#{bank_branch_ref}",
          "account_number": "#{account_number}"
      }.to_json
      k2_response_transfer = k2_https.request(k2_request)
      puts("\nThe Response:\t#{k2_response_transfer.body.to_s}")
      @k2_stk_location = Yajl::Parser.parse(k2_response_transfer.body)["location"]
      puts("\nThe Location Url:\t#{@k2_stk_location}")
      return true
    rescue Exception => e
      puts(e.message)
      return false
    end

    # Create a either a 'blind' transfer, for when destination is specified, and a 'targeted' transfer which has a specified destination.
    def transfer_funds(destination, currency, value)
      set_k2_mocks
      k2_url = URI.parse("#{@postman_k2_mock_server}/transfers")
      k2_https = Net::HTTP.new(k2_url.host, k2_url.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Post.new(k2_url)
      k2_request.add_field('Content-Type', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Accept', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Authorization', "Bearer access_token")
      if destination.nil?
        # Blind Transfer
        k2_request.body = {
            "amount": {
                "currency": "#{currency}",
                "value": "#{value}"
            }
        }.to_json
      else
        # Targeted Transfer
        k2_request.body = {
            "amount": {
                "currency": "#{currency}",
                "value": "#{value}"
            },
            "destination": "#{destination}"
        }.to_json
      end
      @k2_response_transfer = k2_https.request(k2_request)
      puts("\nThe Response:\t#{@k2_response_transfer.body.to_s}")
      @k2_stk_location = Yajl::Parser.parse(@k2_response_transfer.body)["location"]
      puts("\nThe Location Url:\t#{@k2_stk_location}")
    end

    # Check the status of a prior initiated Transfer.
    def query_transfer(id)
      set_k2_mocks
      k2_url = URI.parse("#{@postman_k2_mock_server}/transfers")
      k2_https = Net::HTTP.new(k2_url.host, k2_url.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Get.new(k2_url)
      k2_request.add_field('Accept', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Authorization', "Bearer access_token")
      k2_request.body = {
          "ID": "#{id}"
      }.to_json
      @k2_response_transfer = k2_https.request(k2_request)
      puts("\nThe Response:\t#{@k2_response_transfer.body.to_s}")
    end
  end
end