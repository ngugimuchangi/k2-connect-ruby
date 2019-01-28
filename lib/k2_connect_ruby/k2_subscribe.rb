module K2ConnectRuby
  class K2Subscribe
    attr_accessor :client_id,
                  :client_secret,
                  :redirect_uri,
                  :localhost_site,
                  :subscriber,
                  :subscriber_auth_url,
                  :authorization_code,
                  :subscriber_token
    # Method for subscribing
    def lets_subscribe

    end

    # Method for sending the request to K2 sandbox
    def token_request
      # JSON data
      begin
        @client_id = 'fad40925aefec01b96d3eb3dcd29c2dc43da84544bd69e3e27d507caf2e27b30'
        @client_secret = 'c0810b42dd39c229ab1da87d97813f0d917886ecc4fb532b221998151109c7b1'
        @redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'
        @localhost_site = "http://localhost:3002"
        @subscriber = OAuth2::Client.new(client_id, client_secret, :site => site)
        @subscriber_auth_url = @subscriber.auth_code.authorize_url(:redirect_url => redirect_uri)
        @authorization_code = ""
        @subscriber_token = @subscriber.auth_code.get_token(authorization_code, :redirect_uri =>redirect_uri)
        response = @subscriber_token.get('/api/v1/profiles.json')
        JSON.parse(response.body)
      rescue => e
        puts "Failed #{e}"
      end
      # unsecure TZ site
      # http://www.remax.co.tz/publiclistinglist.aspx#mode=gallery&cr=2&cur=TZS&sb=PriceIncreasing&page=1&sc=115&sid=0441e3a5-17f0-43ba-9370-dfff27910df3
    end



    # def token_request(client_id, client_secret, client_credentials)
    #   # JSON data
    #   begin
    #     # the_uri = URI("https://api-sandbox.kopokopo.com/oauth/v4/token")
    #     # k2_http = Net::HTTP.new(the_uri.host, the_uri.port)
    #     # k2_params = "{'Content-Type': 'application/x-www-form-urlencoded', 'Authorization'=> 'Basic'}"
    #     # k2_req = Net::HTTP::Post.new(the_uri.path, k2_params.to_s)
    #     # k2_req.body = {"client_id": "#{client_id}", "client_secret": "#{client_secret}", "grant_type": "#{client_credentials}"}.to_json
    #     # resp = k2_http.request(k2_req)
    #     # puts ("Response:\t#{resp.body}")
    #     # puts JSON.parse(resp.body)
    #   rescue => e
    #     puts "Failed #{e}"
    #   end
    #   # unsecure TZ site
    #   # http://www.remax.co.tz/publiclistinglist.aspx#mode=gallery&cr=2&cur=TZS&sb=PriceIncreasing&page=1&sc=115&sid=0441e3a5-17f0-43ba-9370-dfff27910df3
    # end
  end
end