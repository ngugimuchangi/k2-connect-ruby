module K2ConnectRuby
  class K2Stk
    attr_accessor :k2_response_stk_receive,
                  :k2_response_stk_query,
                  :k2_stk_location,
                  :postman_k2_mock_server,
                  :postman_k2_mock

    # Sets the Url for the mock server / API server
    def set_k2_mocks
      @postman_k2_mock_server = "https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io"
    end

    # Receive payments from M-PESA users.
    def mpesa_receive_payments(first_name, last_name, phone, email, value)
      set_k2_mocks
      k2_url = URI.parse("#{@postman_k2_mock_server}/payment_requests")
      k2_https = Net::HTTP.new(k2_url.host, k2_url.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Post.new(k2_url)
      k2_request.add_field('Content-Type', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Accept', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Authorization', "Bearer access_token")
      k2_request_subscriber = {
          "first_name": "#{first_name}",
          "last_name": "#{last_name}",
          "phone": "#{phone}",
          "email": "#{email}"
      }.to_json
      k2_request_amount = {
          "currency": "KES",
          "value": "#{value}"
      }.to_json
      k2_request_metadata = {
          "customer_id": "123456789",
          "reference": "123456",
          "notes": "Payment for invoice 12345"
      }.to_json
      k2_request_links = {
          "call_back_url": "https://call_back_to_your_app.your_application.com"
      }.to_json
      k2_request.body = {
          "payment_channel": "M-PESA",
          "till_identifier": "444555",
          "subscriber": k2_request_subscriber,
          "amount": k2_request_amount,
          "metadata": k2_request_metadata,
          "_links": k2_request_links
      }.to_json
      @k2_response_stk_receive = k2_https.request(k2_request)
      puts("\nThe Response:\t#{@k2_response_stk_receive.body.to_s}")
      @k2_stk_location = Yajl::Parser.parse(@k2_response_stk_receive.body)["location"]
      puts("\nThe Location Url:\t#{@k2_stk_location}")
      return true
    rescue Exception => e
      puts(e.message)
      return false
    end

    # Process Payment Request Result for M-PESA payments
    def mpesa_process_payments(the_request)
      raise K2NilRequest if the_request.nil?
      # The Response Body.
      @hash_body = Yajl::Parser.parse(the_request.body.string.as_json)
      # The Response Header
      @hash_header = Yajl::Parser.parse(the_request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
    end

    # Query Payment Request Status
    def mpesa_query_payments(id)
      set_k2_mocks
      k2_url = URI.parse("#{@postman_k2_mock_server}/payment_requests")
      k2_https = Net::HTTP.new(k2_url.host, k2_url.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Get.new(k2_url)
      k2_request.add_field('Accept', 'application/vnd.kopokopo.v4.hal+json')
      k2_request.add_field('Authorization', "Bearer access_token")
      k2_request.body = {
          "ID": "#{id}"
      }.to_json
      @k2_response_stk_query = k2_https.request(k2_request)
      puts("\nThe Response:\t#{@k2_response_stk_query.body.to_s}")
    end
  end
end