module K2BuyGoods
  def self.components(the_body, msisdn, till_no, sys, fname, mname, lname)
    msisdn = the_body.dig("event", "resource", "sender_msisdn")
    till_no = the_body.dig("event", "resource", "till_number")
    sys = the_body.dig("event", "resource", "system")
    fname = the_body.dig("event", "resource", "sender_first_name")
    mname = the_body.dig("event", "resource", "sender_middle_name")
    lname = the_body.dig("event", "resource", "sender_last_name")
  end
end