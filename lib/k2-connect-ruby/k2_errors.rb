module K2ConnectRuby
  # For cases where the access token is not equal to the one provided at K2ConnectRuby::K2Subscribe.token_request()
  class K2AccessTokenError < StandardError
    def message
      STDERR.puts("Invalid Access Token!")
      exit(false )
    end
  end

  # For cases where the secret key is nil/null/empty.
  class K2NilSecretKey < StandardError
    def message
      STDERR.puts("No Secret Key Given!")
      exit(false )
    end
  end

  # For cases where the access token is nil/null/empty.
  class K2NilAccessToken < StandardError
    def message
      STDERR.puts("No Access Token Created!")
      exit(false )
    end
  end

  # For cases where the access token has expired.
  class K2ExpiredToken < StandardError
    def message?
      STDERR.puts("Expired Access Token.")
      exit(false )
    end
  end

  # Raises an error should the body argument be empty
  class K2NilRequestBody < StandardError
    def message
      STDERR.puts("Nil Request Body Argument!")
      exit(false )
    end
  end

  # Raises an error should the empty arguments for authentication
  class K2NilAuthArgument < StandardError
    def message
      STDERR.puts("Nil Authentication Argument!\nCheck for Nil/Null Input in either your Secret Key, Signature or Request Body.")
      exit(false )
    end
  end

  # Raises error concerning a nil request Input in the parse_request or for method
  class K2NilRequest < StandardError
    def message
      STDERR.puts("Nil Request Parameter Input!")
      exit(false )
    end
  end

  # Raises error when no subscription service is selected
  class K2NonExistentSubscription < StandardError
    def message
      STDERR.puts("Subscription Service does not Exist!")
      exit(false )
    end
  end

  # Raises error when registering for repeat token for subscription service
  class K2RepeatTokenRequest < StandardError
    def message
      STDERR.puts("Token already generated for this subscription service!")
      exit(false )
    end
  end

  # Raises error before splitting request should the K2Client not be authenticated
  class K2FalseTruthValue < StandardError
    def message
      STDERR.puts("Unauthorised Signature!")
      exit(false )
    end
  end

end