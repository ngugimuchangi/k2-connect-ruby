# For cases where the access token is not equal to the one provided at K2ConnectRuby::K2Subscribe.token_request()
class K2AccessTokenError < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 401
    @status = :unauthorized
    @message = "Invalid Access Token!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# For cases where the secret key is nil/null/empty.
class K2InvalidHMAC < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 400
    @status = :bad_request
    @message = "Invalid Details Given!\n Ensure that your the Arguments Given to the authenticate? method are correct, namely:\n\t- Secret Key\n\t- Signature\n\t- The Response Body"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# For cases where the secret key is nil/null/empty.
class K2NilSecretKey < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 403
    @status = :forbidden
    @message = "No Secret Key Given!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# For cases where the access token is nil/null/empty.
class K2NilAccessToken < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 400
    @status = :bad_request
    @message = "No Access Token in Argument!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# For cases where the access token has expired.
# Not yet Implemented
class K2ExpiredToken < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 401
    @status = :unauthorized
    @message = "Expired Access Token!"
  end

  def message?
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# Raises an error should the body argument be empty
class K2NilRequestBody < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 400
    @status = :bad_request
    @message = "Nil Request Body Argument!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# Raises an error should the empty arguments for authentication
class K2NilAuthArgument < StandardError
  attr_reader :status, :error, :message
  def initialize(_error=nil, _status=nil)
    @error = 401
    @status = :unauthorized
    @message = "Nil Authentication Argument!\nCheck for Nil/Null Input in either your Secret Key, Signature or Request Body!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
  end
end

# Raises error concerning a nil request Input in the parse_request or for method
class K2NilRequest < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 400
    @status = :bad_request
    @message = "Nil Request Parameter Input!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# Raises error should the uri.scheme not be 'https', thus an insecure connection or request
class K2InsecureRequest < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 400
    @status = :bad_request
    @message = "Insecure Internet Protocol!\n Your Request URL is not secured. Redirecting...."
  end

  def message
    STDERR.puts(@message)
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# Raises error when no subscription service is selected
class K2NonExistentSubscription < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error =  404
    @status = :not_found
    @message = "Subscription Service does not Exist!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordNotFound.new("#{@message}")
  end
end

# Raises error when no event_type specified
class K2NilEvent < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 400
    @status = :bad_request
    @message = "Nil Event Type Specified!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# Raises error when registering for repeat token for subscription service
class K2RepeatTokenRequest < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 400
    @status = :bad_request
    @message = "Token already generated for this Subscription Service!"
  end

  def message
    STDERR.puts(@message)
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# Raises error before splitting request should the truth value be nil
class K2NilTruthValue < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 401
    @status = :unauthorized
    @message = "Nil Value Given!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# Raises error before splitting request should the truth value be invalid
class K2InvalidTruthValue < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 401
    @status = :unauthorized
    @message = "Invalid Truth Value Given!\nNo Boolean Value Given."
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# Raises error before splitting request should the K2Client not be authenticated
class K2FalseTruthValue < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 401
    @status = :unauthorized
    @message = "Unauthorised Signature!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# Raises error for an Invalid Form in which input is given,
# like the response body which should already be hashed in byK2Client before being used elsewhere.
class K2InvalidBody < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 400
    @status = :bad_request
    @message = "Invalid Response Body Form!\n The Response has not been Parsed by the K2Client."
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordInvalid.new("#{@message}")
  end
end

# Raises error before splitting request should the K2Client not be authenticated
class K2UnspecifiedEvent < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 404
    @status = :not_found
    @message = "No Other Specified Event!"
  end

  def message
    STDERR.puts(@message)
    exit(false )
    # raise ActiveRecord::RecordNotFound.new("#{@message}")
  end
end

# Error for Empty Hash Objects (K2Entity validate => input)
class K2EmptyInput < StandardError
  attr_reader :status, :error, :message
  def initialize
    @error = 400
    @status = :bad_request
    @message = "Empty or Nil Input!\n No Input Content has been given."
  end

  def message
    STDERR.puts(@message)
    return false
  end
end

# Hash / Params has Empty Values within it
class K2InvalidHash < StandardError
  attr_reader :status, :error, :message, :the_keys
  def initialize (the_keys)
    @error = 400
    @the_keys  = the_keys
    @status = :bad_request
    @message = "Incorrect Hash Object!\n The Following Params are Empty: "
  end

  def loop_keys
    @the_keys.each_value(&method(:puts))
  end

  def message
    STDERR.puts(@message)
    loop_keys
    # exit(false)
  end
end

# Error for Empty Hash Objects (K2Entity validate => input)
class IncorrectParams < StandardError
  attr_reader :status, :error, :message, :the_keys
  def initialize (the_keys)
    @error = 400
    @the_keys  = the_keys
    @status = :bad_request
    @message = "Incorrect Hash Parameters!\n The Following Params are Incorrect: "
  end

  def loop_keys
    @the_keys.each_value(&method(:puts))
  end

  def message
    STDERR.puts(@message)
    loop_keys
    # exit(false)
  end
end

# These are how to render the errors
# render plain: {error: 'This is my error message.'}, status: 401, content_type: 'application/json'
# raise ActionController::BadRequest.new Works too