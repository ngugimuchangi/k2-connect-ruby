# DISCLAIMER!

The following library has not yet been finalised to production, and as such, not ready to be consumed as a gem. 

# K2ConnectRuby

Ruby SDK for connection to the Kopo Kopo API.
This documentation gives you the specifications for connecting your systems to the Kopo Kopo Application.
Primarily you can connect to the Kopo Kopo system to perform the following:

 - Receive Webhook notifications.
 - Receive payments from your users/customers.
 - Initiate payments to third parties.
 - Initiate transfers to your settlement accounts.
 
Please note, all requests MUST be made over HTTPS.
Any non-secure requests are met with a redirect (HTTP 302) to the HTTPS equivalent URI.
All calls made without authentication will also fail.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'k2-connect-ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install k2-connect-ruby

## Usage

Initially, you add the require line:

```ruby
require 'k2-connect-ruby'
```

### Authentication

In order to request for application authorization we need to execute the client credentials flow, this is done so by having your application server make a HTTP request to the Kopo Kopo authorization server, through the K2Subscribe class.

First Create an Object of the K2Subscription class, while passing an event-type parameter that is necessary to differentiate which Webhook Subscription you are identifying.

 - For Buygoods Transaction Received

```ruby
buygoods_received = K2ConnectRuby::K2Subscribe.new("buygoods_transaction_received")
```

- For Buygoods Transaction Reversed

```ruby
buygoods_reversed = K2ConnectRuby::K2Subscribe.new("buygoods_transaction_reversed")
```

 - For Customer Created

```ruby
customer_create = K2ConnectRuby::K2Subscribe.new("customer_created")
```

 - For Settlement Transfer Completed

```ruby
settlement_transfer = K2ConnectRuby::K2Subscribe.new("settlement_transfer_completed")
```

Next is to request for the token, done through the recently created K2Subscribe Object. From here you will pass in your client_id and client_secret details.

 ```ruby
 buygoods_reversed.token_request(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"])
 ```
 
 ##### Remember to store highly sensitive and core details like the client_id, client_secret, access_token and such in a config file, while ensuring that they are indicated in your .gitgnore file so that they are not uploaded to Github.

Next, we formally create the webhook subscription by calling on the following method:

```ruby
 buygoods_reversed.webhook_subscribe
```
 
 The event-type parameter specified during creating the K2Subscription Object will be used to specify what event type we intend to use.
 
 
 ### STK-Push
 
 To receive payments from M-PESA users via STK Push we first create a K2Stk Object from which the other functions will be accessed through.
 
    k2_stk = K2ConnectRuby::K2Stk.new
  
 - Afterwards we send a POST request for receiving Payments by calling the following method and passing the params value received from the POST Form Request:
  
```ruby
 k2_stk.mpesa_receive_payments(params)
```

A Successful Response will be received containing the URL of the Payment Location.

 - To Process the Payment Request Result

 - To Query the STK Payment Request Status pass the reference number or id to the following method as shown:

```ruby
 k2_stk.mpesa_query_payments(params[:stk_id])
```

### PAY

First Create the K2Pay Object

```ruby
 k2_pay = K2ConnectRuby::K2Pay.new
```

 - To Add PAY Recipients, a request is sent by calling:
  
```ruby
 k2_pay.pay_recipients(params)
```

The Params are passed as the argument containing all the form data sent. A Successful Response is returned with the URL of the recipient resource in the HTTP Location Header.

 - To Create Outgoing PAYment to a third party.

```ruby
 @k2_pay.pay_create(params)
```

The Params are passed as the argument containing all the form data sent. A Successful Response is returned with the URL of the Payment resource in the HTTP Location Header.

 - To Process the PAYment Result

 - To Query the PAYment Request Status pass the reference number or payment_id to the following method as shown:

```ruby
 k2_pay.query_pay(params[:payment_id])
```

### Transfers

This will Enable one to transfer funds to your pre-approved settlement accounts.

First Create the K2Transfer Object

```ruby
 k2_transfers = K2ConnectRuby::K2Transfer.new
```

 - Create a Verified Settlement Account through the following method:
  
```ruby
 k2_transfers.settlement_account(params)
```

The Params are passed as the argument having all the form data. A Successful Response is returned with the URL of the merchant bank account in the HTTP Location Header.

 - To Create Transfer Request, one can either have it `blind`, meaning that it has no specified destination with the default/specified settlement account being selected, 
or one can have a `targeted` transfer with a specified settlement account in mind. Either can be done through:

 - For a **Blind** Transfer:

```ruby
 k2_transfers.transfer_funds(nil, params)
```

With `nil` representing that there are no specified destinations.

- For a **Target** Transfer:

```ruby
 k2_transfers.transfer_funds(params[:destination], params)
```

The Params are passed as the argument containing all the form data sent. A Successful Response is returned with the URL of the Transfer in the HTTP Location Header.

 - To Query the status of the prior initiated Transfer Request pass the reference number or payment_id to the following method as shown:

```ruby
 k2_transfers.query_transfer("#{params[:transfer_id]}")
```

A HTTP Response will be returned in a JSON Payload.

### Parsing the JSON Payload

The K2Client class will be use to parse the Payload received from Kopo Kopo, and to further consume the webhooks and split the responses into components, the K2Authenticator and
K2SplitRequest Classes will be used.

 - First Create an Object of the K2Client class to Parse the response, passing the client_secret_key received from Kopo Kopo:

```ruby
 k2_test = K2ConnectRuby::K2Client.new(ENV["K2_SECRET_KEY"])
```

##### Remember to have kept it safe in a config file, it is highly recommended so as to keep it safe. Also add that specific config file destination in your .gitignore.

 - Next, parse the request:

```ruby
 k2_test.parse_request(request)
```

 - Authenticating the Response to ensure it came from Kopo Kopo:

```ruby
 k2_truth_value = K2ConnectRuby::K2Authenticator.new.authenticate?(k2_test.hash_body, k2_test.api_secret_key, k2_test.k2_signature)
```

 - Creating a K2SplitRequest Object, while passing the return value from the Authenticator `authenticate?` method:

```ruby
 k2_components = K2ConnectRuby::K2SplitRequest.new(k2_truth_value)
```

 - Finally, to formally split the request:

```ruby
 k2_components.judge_truth(response.body)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/k2-connect-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the K2ConnectRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/k2-connect-ruby/blob/master/CODE_OF_CONDUCT.md).
