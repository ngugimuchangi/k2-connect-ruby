module K2ConnectRuby
  class K2SplitRequest
    # Splits the Body into the different elements of the request body.
    def request_body_components(the_req_body)
      the_req_body.extend Hashie::Extensions::DeepFind
      puts("\nTopic:\t#{the_req_body["topic"]}\nReference:\t#{JSON.parse(the_req_body.deep_select("reference").to_s).join(', ')}\nMSISDN:\t#{JSON.parse(the_req_body.deep_select("sender_msisdn").to_s).join(', ')}\nAmount:\t#{JSON.parse(the_req_body.deep_select("amount").to_s).join(', ')}\nCurrency:\t#{JSON.parse(the_req_body.deep_select("currency").to_s).join(', ')}\nTill Number:\t#{JSON.parse(the_req_body.deep_select("till_number").to_s).join(', ')}\nSystem:\t#{JSON.parse(the_req_body.deep_select("system").to_s).join(', ')}\nSender First Name:\t#{JSON.parse(the_req_body.deep_select("sender_first_name").to_s).join(', ')}\nSender Middle Name:\t#{JSON.parse(the_req_body.deep_select("sender_middle_name").to_s).join(', ')}\nSender Last Name:\t#{JSON.parse(the_req_body.deep_select("sender_last_name").to_s).join(', ')}\n")
    end
  end
end