module K2ConnectRuby
  class K2Pay
    attr_accessor :k2_response_pay,
                  :postman_mock_server,
                  :params_body

    # https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io mock server
    # def initialize(postman_mock_server)
    #   @postman_mock_server = postman_mock_server
    # end

    # Sets the Url for the mock server / API server
    def set_k2_mocks
      @postman_k2_mock_server = "https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io"
    end

    # Adding PAY Recipients with either mobile_wallets or bank_accounts as destination of your payments.
    # The Params from the form are passed through.
    def pay_recipients(pay_recipient_params)
      set_k2_mocks
      k2_url = URI.parse("#{@postman_k2_mock_server}/pay_recipients")
      k2_https = Net::HTTP.new(k2_url.host, k2_url.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Post.new(k2_url)
      k2_request.add_field('Content-Type', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Accept', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Authorization', "Bearer access_token")
      case
        # In the case of mobile pay
      when pay_recipient_params["pay_type"].match?("mobile_wallet")
        k2_request_pay_recipient = {
            "firstName": "#{pay_recipient_params["first_name"]}",
            "lastName": "#{pay_recipient_params["last_name"]}",
            "phone": "#{pay_recipient_params["phone"]}",
            "email": "#{pay_recipient_params["email"]}",
            "network": "#{pay_recipient_params["network"]}"
        }.to_json
        # In the case of bank pay
      when pay_recipient_params["pay_type"].match?("bank_account")
        k2_request_pay_recipient = {
            "name": "#{pay_recipient_params["first_name"]} #{pay_recipient_params["last_name"]}",
            "account_name": "#{pay_recipient_params["acc_name"]}",
            "bank_id": "#{pay_recipient_params["bank_id"]}",
            "bank_branch_id": "#{pay_recipient_params["bank_branch_id"]}",
            "account_number": "#{pay_recipient_params["acc_no"]}",
            "email": "#{pay_recipient_params["pay_type"]}",
            "phone": "#{pay_recipient_params["email"]}"
        }.to_json
      else
        k2_request_pay_recipient = nil
      end
      k2_request.body = {
          "type": "#{pay_recipient_params["pay_type"]}",
          "pay_recipient": k2_request_pay_recipient
      }.to_json
      @k2_response_pay = k2_https.request(k2_request)
      puts("\nThe Response:\t#{@k2_response_pay.body.to_s}")
      @k2_stk_location = Yajl::Parser.parse(@k2_response_pay.body)["location"]
      puts("\nThe Location Url:\t#{@k2_stk_location}")
      return true
    rescue Exception => e
      puts(e.message)
      return false
    end

    # Create an outgoing Payment to a third party.
    def pay_create(pay_create_params)
      set_k2_mocks
      k2_url = URI.parse("#{@postman_k2_mock_server}/payments")
      k2_https = Net::HTTP.new(k2_url.host, k2_url.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Post.new(k2_url)
      k2_request.add_field('Content-Type', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Accept', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Authorization', "Bearer access_token")
      k2_request_pay_amount = {
          "currency": "#{pay_create_params["currency"]}",
          "value": "#{pay_create_params["value"]}"
      }.to_json
      k2_request_pay_metadata = {
          "customerId": "8675309",
          "notes": "Salary payment for May 2018"
      }.to_json
      k2_request_pay_links = {
          "callback_url": "https://your-call-bak.yourapplication.com/payment_result"
      }.to_json
      k2_request.body = {
          "destination": "c7f300c0-f1ef-4151-9bbe-005005aa3747",
          "amount": k2_request_pay_amount,
          "metadata": k2_request_pay_metadata,
          "_links": k2_request_pay_links
      }.to_json
      @k2_response_pay = k2_https.request(k2_request)
      puts("\nThe Response:\t#{@k2_response_pay.body.to_s}")
      @k2_stk_location = Yajl::Parser.parse(@k2_response_pay.body)["location"]
      puts("\nThe Location Url:\t#{@k2_stk_location}")
      return true
    rescue Exception => e
      puts(e.message)
      return false
    end

    # Process Pay Result Asynchronously after Payment is initiated
    def process_pay(the_request)
      raise K2NilRequest if the_request.nil?
      # The Response Body.
      @hash_body = Yajl::Parser.parse(the_request.body.string.as_json)
      # The Response Header
      @hash_header = Yajl::Parser.parse(the_request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
    end

    # Query the status of a previously initiated Payment request
    def query_pay(id)
      set_k2_mocks
      k2_url = URI.parse("#{@postman_k2_mock_server}/payments")
      k2_https = Net::HTTP.new(k2_url.host, k2_url.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Get.new(k2_url)
      k2_request.add_field('Accept', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Authorization', "Bearer access_token")
      k2_request.body = {
          "ID": "#{id}"
      }.to_json
      @k2_response_pay = k2_https.request(k2_request)
      puts("\nThe Response:\t#{@k2_response_pay.body.to_s}")
    end

  end
end