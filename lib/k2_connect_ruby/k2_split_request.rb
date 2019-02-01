module K2ConnectRuby
  class K2SplitRequest
    attr_accessor :topic,
                  :reference_number,
                  :msisdn,
                  :amount,
                  :currency,
                  :till_number,
                  :system,
                  :first_name,
                  :middle_name,
                  :last_name,
                  :truth_value
    # before_action :judge_truth, only: [:initialize]

    # Initialize with a truth Value
    def initialize(truth_value)
      @truth_value = truth_value
    end

    # Confirm Truth value and carry out splitting
    def judge_truth(the_body)
      raise K2Errors::K2NilRequestBody if the_body.nil?
      if @truth_value
        request_body_components(the_body)
      else

      end
    rescue Exception => e
      puts(e.message)
    end

    # Splits the Body into the different elements of the request body.
    def request_body_components(the_body)
      @topic = the_body.dig("topic")
      @reference_number = the_body.dig("event", "resource", "reference")
      @msisdn = the_body.dig("event", "resource", "sender_msisdn")
      @amount = the_body.dig("event", "resource", "amount")
      @currency = the_body.dig("event", "resource", "currency")
      @till_number = the_body.dig("event", "resource", "till_number")
      @system = the_body.dig("event", "resource", "system")
      @first_name = the_body.dig("event", "resource", "sender_first_name")
      @middle_name = the_body.dig("event", "resource", "sender_middle_name")
      @last_name = the_body.dig("event", "resource", "sender_last_name")
    rescue Exception => e
      puts(e.message)
    end

    private :request_body_components

  end
end