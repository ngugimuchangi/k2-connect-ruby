module K2ConnectRubyApiGem
  class Client
    @secret_key
    def initialize(secret_key)
      @secret_key = secret_key
    end

    # Method for comparing the HMAC and with HTTP_X_KOPOKOPO_SIGNATURE
    def authorize_it(message_body, comparison_signature)
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.hexdigest(digest, @secret_key, message_body)
      # puts("\n\nMessage Body: #{message_body}\n\nX-K2-Signature: #{JSON.parse(comparison_signature).join(', ')}\n\n The HMAC hash: #{hmac}")
      return hmac.to_s.eql?(JSON.parse(comparison_signature).join(', '))
    end

    def parse_it_whole(the_req)
      # The Response Body
      hash_body = Yajl::Parser.parse(the_req.body.string.to_json)
      # The Response Header
      hash_header = Yajl::Parser.parse(the_req.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
      # The Response Method
      hash_method = Yajl::Parser.parse(the_req.method.to_json)
      hash_header.extend Hashie::Extensions::DeepFind
      hash_body.extend Hashie::Extensions::DeepFind
      puts(hash_body.deep_select("TOPIC").to_s)
      puts ("Hello")
      if hash_method.eql?("POST")
        if authorize_it(hash_body.to_s, hash_header.deep_select("HTTP_X_KOPOKOPO_SIGNATURE").to_s)
          assign_req_elements(hash_body) and return
          return 200
        else
          return 401
        end
      else
        return 400
      end
    end

    def assign_req_elements(the_req_body)
      the_req_body.extend Hashie::Extensions::DeepFind
      k2_topic = the_req_body.deep_select("topic").to_s
      k2_reference= the_req_body.deep_select("reference").to_s
      k2_msisdn= the_req_body.deep_select("msisdn").to_s
      k2_amount= the_req_body.deep_select("amount").to_s
      k2_currency= the_req_body.deep_select("currency").to_s
      k2_till_number= the_req_body.deep_select("till_number").to_s
      k2_system= the_req_body.deep_select("system").to_s
      k2_sender_first_name= the_req_body.deep_select("sender_first_name").to_s
      k2_sender_middle_name= the_req_body.deep_select("sender_middle_name").to_s
      k2_sender_last_name= the_req_body.deep_select("sender_last_name").to_s
      puts("\n\nTopic:\t#{k2_topic}\nReference:\t#{k2_reference}\nMSISDN:\t#{k2_msisdn}\nAmount:\t#{k2_amount}\nCurrency:\t#{k2_currency}\nTill Number:\t#{k2_till_number}\nSystem:\t#{k2_system}\nSender First Name:\t#{k2_sender_first_name}\nSender Middle Name:\t#{k2_sender_middle_name}\nSender Last Name:\t#{k2_sender_last_name}\n")
    end
  end
end