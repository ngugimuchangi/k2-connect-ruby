module K2ConnectRuby
  # For cases where the access token is not equal to the one provided at K2ConnectRuby::K2Subscribe.token_request()
  class K2AccessTokenError < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 401
      @status = _status || :unauthorized
    end

    def message
      STDERR.puts("Invalid Access Token!")
      exit(false )
    end
  end

  # For cases where the secret key is nil/null/empty.
  class K2NilSecretKey < StandardError
    attr_reader :status, :error, :message
    def initialize(_error=nil, _status=nil, _message=nil)
      @error = 403
      @status = :forbidden
      @message = "No Secret Key Given!"
    end

    def message
      STDERR.puts("No Secret Key Given!")
      render plain: {error: "#{@message}"}, status: @error, content_type: 'application/json'
      raise ActiveRecord::RecordNotFound.new("#{@message}")
    end
  end

  # For cases where the access token is nil/null/empty.
  class K2NilAccessToken < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 400
      @status = _status || :bad_request
    end

    def message
      STDERR.puts("No Access Token in Argument!")
      exit(false )
    end
  end

  # For cases where the access token has expired.
  # Not yet Implemented
  class K2ExpiredToken < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 401
      @status = _status || :unauthorized
    end

    def message?
      STDERR.puts("Expired Access Token.")
      exit(false )
    end
  end

  # Raises an error should the body argument be empty
  class K2NilRequestBody < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 400
      @status = _status || :bad_request
    end

    def message
      STDERR.puts("Nil Request Body Argument!")
      exit(false )
    end
  end

  # Raises an error should the empty arguments for authentication
  class K2NilAuthArgument < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 401
      @status = _status || :unauthorized
    end

    def message
      STDERR.puts("Nil Authentication Argument!\nCheck for Nil/Null Input in either your Secret Key, Signature or Request Body.")
      exit(false )
    end
  end

  # Raises error concerning a nil request Input in the parse_request or for method
  class K2NilRequest < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 400
      @status = _status || :bad_request
    end

    def message
      STDERR.puts("Nil Request Parameter Input!")
      exit(false )
    end
  end

  # Raises error when no subscription service is selected
  class K2NonExistentSubscription < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 404
      @status = _status || :not_found
    end

    def message
      STDERR.puts("Subscription Service does not Exist!")
      exit(false )
    end
  end

  # Raises error when no event_type specified
  class K2NilEvent < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 400
      @status = _status || :bad_request
    end

    def message
      STDERR.puts("No Event Type Specified!")
      exit(false )
    end
  end

  # Raises error when registering for repeat token for subscription service
  class K2RepeatTokenRequest < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 400
      @status = _status || :bad_request
    end

    def message
      STDERR.puts("Token already generated for this Subscription Service!")
      exit(false )
    end
  end

  # Raises error before splitting request should the K2Client not be authenticated
  class K2FalseTruthValue < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 401
      @status = _status || :unauthorized
    end

    def message
      STDERR.puts("Unauthorised Signature!")
      exit(false )
    end
  end

  # Raises error before splitting request should the K2Client not be authenticated
  class K2UnspecifiedEvent < StandardError
    attr_reader :status, :error
    def initialize(_error=nil, _status=nil)
      @error = _error || 404
      @status = _status || :not_found
    end

    def message
      STDERR.puts("No Other Specified Event!")
      exit(false )
    end
  end

end


# These are how to render the errors
# render plain: {error: 'This is my error message.'}, status: 401, content_type: 'application/json'
# raise ActionController::BadRequest.new Works too