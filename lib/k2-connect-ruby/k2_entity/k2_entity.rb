class K2Entity
  attr_accessor :k2_access_token

  # Initialize with access token from Subscriber Class
  def initialize(access_token)
    @k2_access_token = access_token
  end

  # Method for Validating the input itself
  def validate_input(the_input)
    if the_input.empty?

    end
    if the_input.is_a?(Hash)
      if the_input.empty?
        raise K2EmptyHash.new
      else
        validate_hash the_input
      end
    else
      validate_id the_input
    end
  rescue K2EmptyHash => k2
    puts(k2.message)
  rescue TypeError => te
    puts(te.message)
  end

  # Validate the Hash Input Parameters
  def validate_hash(the_input)
    empty_keys = {}
    nil_params(the_input, empty_keys) and return
    unless empty_keys.empty?
      raise K2InvalidHash.new(empty_keys)
    end
  rescue K2InvalidHash => k2
    puts(k2.message)
  end

  # Nil or Empty Values in Hash
  def nil_params(the_input, times= 0, nil_keys)
    while times < the_input.select{|_,v| v.nil? || v == ""}.keys.length
      the_input.select{|_,v| v.nil? || v == ""}.keys.each do |a|
        nil_keys[times] = a
        times += 1
      end
    end
  end

  # Validate the ID
  def validate_id(the_input)
  end

  # Process Payment Result
  def process_payment(the_request)
    raise K2NilRequest.new if the_request.nil?
    # The Response Body.
    hash_body = Yajl::Parser.parse(the_request.body.string.as_json)
    # The Response Header
    hash_header = Yajl::Parser.parse(the_request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
  rescue K2NilRequest => k2
    puts(k2.message)
  end

end