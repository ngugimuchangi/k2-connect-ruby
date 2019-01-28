module K2ConnectRuby
  class K2SplitRequest
    attr_accessor :topic, :reference_number, :msisdn, :amount, :currency, :till_number, :system, :first_name, :middle_name, :last_name
                  # Splits the Body into the different elements of the request body.
    def request_body_components(the_body)
      # puts("\nTopic:\t#{the_req_body["topic"]}\nReference:\t#{JSON.parse(the_req_body.deep_select("reference").to_s).join(', ')}\nMSISDN:\t#{JSON.parse(the_req_body.deep_select("sender_msisdn").to_s).join(', ')}\nAmount:\t#{JSON.parse(the_req_body.deep_select("amount").to_s).join(', ')}\nCurrency:\t#{JSON.parse(the_req_body.deep_select("currency").to_s).join(', ')}\nTill Number:\t#{JSON.parse(the_req_body.deep_select("till_number").to_s).join(', ')}\nSystem:\t#{JSON.parse(the_req_body.deep_select("system").to_s).join(', ')}\nSender First Name:\t#{JSON.parse(the_req_body.deep_select("sender_first_name").to_s).join(', ')}\nSender Middle Name:\t#{JSON.parse(the_req_body.deep_select("sender_middle_name").to_s).join(', ')}\nSender Last Name:\t#{JSON.parse(the_req_body.deep_select("sender_last_name").to_s).join(', ')}\n")
      @topic = the_body.dig(:event, :resource, :topic)
      # ["event"]["resource"]["topic"]
      # @reference_number = the_body["event"]["resource"]["reference"]
      # @msisdn = the_body["event"]["resource"]["sender_msisdn"]
      # @amount = the_body["event"]["resource"]["amount"]
      # @currency = the_body["event"]["resource"]["currency"]
      # @till_number = the_body["event"]["resource"]["till_number"]
      # @system = the_body["event"]["resource"]["system"]
      # @first_name = the_body["event"]["resource"]["sender_first_name"]
      # @middle_name = the_body["event"]["resource"]["sender_middle_name"]
      # @last_name = the_body["event"]["resource"]["sender_last_name"]
      puts("\n\nThe Topic:\t#{topic}")
    end
  end
end