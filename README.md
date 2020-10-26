# DISCLAIMER!!

The following library has yet to be finalised to production, and as such, neither consumable or usable as a gem/ruby library.

# K2ConnectRuby For Rails

Ruby SDK for connection to the Kopo Kopo API.
This documentation gives you the specifications for connecting your systems to the Kopo Kopo Application.
Primarily, the library provides functionality to do the following:

 - Receive Webhook notifications.
 - Receive payments from your users/customers.
 - Initiate payments to third parties.
 - Initiate transfers to your settlement accounts.
 
The library is optimized for **Rails Based Frameworks**.
Please note, all requests MUST be made over HTTPS.
Any non-secure requests are met with a redirect (HTTP 302) to the HTTPS equivalent URI.
All calls made without authentication will also fail.

## LINKS

 - [Installation](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#installation)
 - [Usage](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#installation)
    - [Authorization](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#authorization)
    - [Webhook Subscription](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#webhook-subscription)
    - [STK Push](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#stk-push)
    - [PAY](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#pay)
    - [Transfers](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#transfers)
    - [Parsing the JSON Payload](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#parsing-the-json-payload)
 - [Development](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#development)
 - [Author](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#author)
 - [Contributing](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#contributing)
 - [License](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#license)
 - [Changelog](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#changelog)
 - [Code of Conduct](https://github.com/DavidKar1uk1/k2-connect-ruby/tree/development#code-of-conduct)

## Installation

Add this line to your application's Gemfile:

    gem 'k2-connect-ruby'

And then execute:

    $ bundle install

Or install it yourself:

    $ gem install k2-connect-ruby

## Usage

Add the require line to use the gem:

    require 'k2-connect-ruby'

### Authorization

Ensure you first Register your application with the [Kopo Kopo Sandbox](To be added later when launched).
Once an application is registered you will obtain your `client_id` and `client_secret` (aka client credentials), which will be used to identify your application when calling the Kopo Kopo API.

For more Information, visit our [API docs]().

In order to request for application authorization and receive an access token, we need to execute the client credentials flow, this is done so by having your application server make a HTTPS request to the Kopo Kopo authorization server, through the K2AccessToken class.

```ruby
k2_token = K2AccessToken.new('your_client_id', 'your_client_secret').token_request
```

### Webhook Subscription

##### Remember to store highly sensitive information like the client credentials, in a config file, while indicating in your .gitignore file.

Next, we formally create the webhook subscription by calling on the webhook_subscribe method.
Ensure the following arguments are passed: 
 - client secret `REQUIRED`
 - event type `REQUIRED`
 - url `REQUIRED`
 - scope `REQUIRED`
 - scope reference `REQUIRED`
 
Code example;
    
```ruby
require 'k2-connect-ruby'
k2_token = K2AccessToken.new('your_client_id', 'your_client_secret').token_request
k2subscriber = K2Subscribe.new(k2_token)
k2subscriber.webhook_subscribe(ENV["K2_SECRET_KEY"], your_input)
```
 
 
 ### STK-Push
 
 #### Receive Payments
 
 To receive payments from M-PESA users via STK Push we first create a K2Stk Object, passing the access_token that was created prior.
 
    k2_stk = K2Stk.new(your_access_token)
  
 Afterwards we send a POST request for receiving Payments by calling the following method and passing the params value received from the POST Form Request: 

    k2_stk.receive_mpesa_payments(your_input)
    
Ensure the following arguments are passed: 
 - first_name `REQUIRED`
 - last_name `REQUIRED`
 - phone `REQUIRED`
 - email `REQUIRED`
 - currency `REQUIRED`
 - value `REQUIRED`

A Successful Response will be received containing the URL of the Payment Location.

#### Query Request Status

 To Query the STK Payment Request Status pass the Payment location URL response that is returned:

    k2_stk.query_resource(k2_stk.location_url)

As a result a JSON payload will be returned, accessible with the k2_response_body variable.
 
Code example;
    
```ruby
k2_stk = K2Stk.new(your_access_token)
k2_stk.receive_mpesa_payments(your_input)
k2_stk.query_resource(k2_stk.location_url)
```

### PAY

First Create the K2Pay Object passing the access token


    k2_pay = K2Pay.new(access_token)

#### Add PAY Recipients

Add a PAY Recipient, with the following arguments:

**Mobile** PAY Recipient
- type: 'mobile_wallet' `REQUIRED`
- first_name `REQUIRED`
- last_name `REQUIRED`
- phone `REQUIRED`
- email `REQUIRED`
- network `REQUIRED`

**Bank** PAY Recipient
- type: 'bank_account' `REQUIRED`
- first_name `REQUIRED`
- last_name `REQUIRED`
- phone `REQUIRED`
- email `REQUIRED`
- account_name `REQUIRED`
- account_number `REQUIRED`
- bank_id `REQUIRED`
- bank_branch_id `REQUIRED`

  
    k2_pay.add_recipients(your_input)
    
The type value can either be `mobile_wallet` or `bank_account`

A Successful Response is returned with the URL of the recipient resource.

#### Create Outgoing Payment

Creating an Outgoing Payment to a third party.

    k2_pay.create_payment(your_input)
    
The following arguments should be passed:

- currency `REQUIRED`
- value `REQUIRED`

A Successful Response is returned with the URL of the Payment resource in the HTTP Location Header.

#### Query PAYment Request Status

To Query the status of the Add Recipient or Outgoing Payment request::

    // add recipient
    k2_pay.query_resource(k2_pay.recipients_location_url)
    // create outgoing payment 
    k2_pay.query_resource(k2_pay.payments_location_url)

As a result a JSON payload will be returned, accessible with the k2_response_body variable.
 
Code example;
    
```ruby
k2_pay = K2Pay.new(your_access_token)
k2_pay.add_recipient(your_input)
k2_pay.query_resource(k2_pay.recipients_location_url)
k2_pay.create_payment(your_input)
k2_pay.query_resource(k2_pay.payments_location_url)
```

### Settlement Accounts

Add pre-approved settlement accounts, to which one can transfer funds to. Can be either a bank or mobile wallet account,
 with the following details:

**Mobile** Settlement Account
- type: 'merchant_wallet' `REQUIRED`
- first_name `REQUIRED`
- last_name `REQUIRED`
- phone_number `REQUIRED`
- network: 'Safaricom' `REQUIRED`

**Bank** Settlement Account
- type: 'merchant_bank_account' `REQUIRED`
- account_name `REQUIRED`
- account_number `REQUIRED`
- bank_ref `REQUIRED`
- bank_branch_ref `REQUIRED`
- settlement_method `REQUIRED`

```ruby
k2_settlement = K2Settlement.new(your_access_token)
# Add a mobile merchant wallet
k2_settlement.add_settlement_account(merchant_wallet)
# Add a merchant bank account
k2_settlement.add_settlement_account(merchant_bank_account)
```

### Transfers

This will Enable one to transfer funds to your settlement accounts.

First Create the K2Transfer Object

    k2_transfers = K2Transfer.new(access_token)

#### Create Transfer Request

One can either have it `blind`, meaning that it has no specified destination with the default/specified settlement account being selected, 
or one can have a `targeted` transfer with a specified settlement account in mind. Either can be done through:

##### Blind Transfer

     k2_transfers.transfer_funds(nil, params)

With `nil` representing that there are no specified destinations.

##### Target Transfer

     k2_transfers.transfer_funds(params)
      
The Following Details should be passed for either **Blind** or **Targeted** Transfer:

**Blind** Transfer
- destination_type: `merchant_wallet` or `merchant_bank_account` `REQUIRED`
- currency `REQUIRED`
- value `REQUIRED`
- callback_url `REQUIRED`

**Targeted** Transfer
- destination_reference `REQUIRED`
- destination_type: `merchant_wallet` or `merchant_bank_account` `REQUIRED`
- currency `REQUIRED`
- value `REQUIRED`
- callback_url `REQUIRED`

The Params are passed as the argument containing all the form data sent. A Successful Response is returned with the URL of the Transfer in the HTTP Location Header.

Sample code example:

```ruby
# TODO Confirm for Blind Transfer
k2_transfer = K2Transfer.new(your_access_token)
# Blind or Targeted Transfer
k2_transfer.transfer_funds(your_input)
```

#### Query Prior Transfer

To Query the status of the prior initiated Transfer Request pass the location_url response as shown:

     k2_transfers.query_resource(k2_transfers.location_url)  

A HTTP Response will be returned in a JSON Payload, accessible with the k2_response_body variable.

### Parsing the JSON Payload

The K2Client class will be use to parse the Payload received from Kopo Kopo, and to further consume the webhooks and split the responses into components, the K2Authenticator and
K2ProcessResult Classes will be used.

###### K2Client Object

First Create an Object of the K2Client class to Parse the response, passing the client_secret_key received from Kopo Kopo:

     k2_parse = K2Client.new(client_secret)

###### Parse the request

     k2_parse.parse_request(request)

###### Create an Object 

Create an Object to receive the components resulting from processing the parsed request results which will be returned by the following method:

     k2_components = K2ProcessResult.process(k2_parse.hash_body)
     
Code example:

```ruby
k2_parse = K2Client.new(client_secret)
k2_parse.parse_request(request)
k2_components = K2ProcessResult.process(k2_parse.hash_body)
```
         
 Below is a list of key symbols accessible for each of the Results retrieved after processing it into an Object.
 
1. Buy Goods Transaction Received:
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `event_type`
    - `reference`
    - `origination_time`
    - `sender_msisdn`
    - `amount`
    - `currency`
    - `till_number`
    - `system`
    - `resource_status`
    - `sender_first_name`
    - `sender_last_name`
    - `links_self`
    - `links_resource`
    
2. Buy Goods Transaction Reversed. Has the same key symbols as Buy Goods Transaction Received. 
    
3. Settlement Transfer:
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `type`
    - `reference`
    - `origination_time`
    - `transfer_time`
    - `transfer_type`
    - `amount`
    - `currency`
    - `resource_status`
    - `destination`
    - `destination_type`
    - `msisdn`
    - `destination_mm_system`
    - `links_self`
    - `links_resource`

4. Customer Created:
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `type`
    - `first_name`
    - `middle_name`
    - `last_name`
    - `msisdn`
    - `self`
    - `resource`
    
5. B2b Transaction Transaction (External Till to Till):
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `type`
    - `reference`
    - `origination_time`
    - `amount`
    - `currency`
    - `till_number`
    - `system`
    - `status`
    - `self`
    - `resource`
    - `sending_till`

6. Merchant to Merchant Transaction:
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `type`
    - `reference`
    - `origination_time`
    - `amount`
    - `currency`
    - `resource_status`
    - `self`
    - `resource`
    - `sending_merchant`
    
7. Process STK Push Payment Request Result
    - `id`
    - `type`
    - `initiation_time`
    - `status`
    - `event_type`
    - `transaction_reference`
    - `origination_time`
    - `msisdn`
    - `amount`
    - `currency`
    - `till_number`
    - `system`
    - `sender_first_name`
    - `sender_last_name`
    - `errors`
    - `metadata`
    - `links_self`
    - `callback_url`

8. Process PAY Result
    - `id`
    - `type`
    - `initiation_time`
    - `status`
    - `transaction_reference`
    - `origination_time`
    - `destination`
    - `currency`
    - `value`: refers to the amount
    - `metadata`
    - `links_self`
    - `callback_url`
    
If you want to convert the Object into a Hash or Array, the following methods can be used.
- Hash:
   
   
        k2_hash_components = K2ProcessResult.return_obj_hash(k2_components)
    
    
- Array:
   
    
        k2_array_components = K2ProcessResult.return_obj_array(k2_components)


Sample Web Application examples written in Rails and Sinatra frameworks that utilize this library are available in the example_app folder or in the following GitHub hyperlinks:

 - [Rails example application](https://github.com/DavidKar1uk1/kt_tips_rails)

 - [Sinatra example application](https://github.com/DavidKar1uk1/kt_tips)
 
 ##### Take Note; the Library is optimized for Rails frameworks version 5.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Author

**Name**:   [David Kariuki Mwangi](https://github.com/DavidJonKariz)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kopokopo/k2-connect-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License].

## Changelog



## Code of Conduct

Everyone interacting in the K2ConnectRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kopokopo/k2-connect-ruby/blob/master/CODE_OF_CONDUCT.md).
