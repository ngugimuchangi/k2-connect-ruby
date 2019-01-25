module K2ConnectRuby
  class K2Subscribe
    # Method for subscribing
    def lets_subscribe

    end

    # Method for sending the request to K2 sandbox
    def token_request(client_id, client_secret, client_credentials)
      # The return response
      k2_resp = k2_http.request(k2_req)
      # JSON data
      begin
        the_uri = URI("https://api-sandbox.kopokopo.com/oauth/v4/token")
        k2_http = Net::HTTP.new(the_uri.host, the_uri.port)
        k2_params = "{'Content-Type': 'application/x-www-form-urlencoded', 'Authorization'=> 'Basic'}"
        k2_req = Net::HTTP::Post.new(the_uri.path, k2_params.to_s)
        k2_req.body = {"client_id": "#{client_id}", "client_secret": "#{client_secret}", "grant_type": "#{client_credentials}"}.to_json
        resp = k2_http.request(k2_req)
        puts ("Response:\t#{resp.body}")
        puts JSON.parse(resp.body)
      rescue => e
        puts "failed #{e}"
      end
      # unsecure TZ site
      # http://www.remax.co.tz/publiclistinglist.aspx#mode=gallery&cr=2&cur=TZS&sb=PriceIncreasing&page=1&sc=115&sid=0441e3a5-17f0-43ba-9370-dfff27910df3
    end
  end
end