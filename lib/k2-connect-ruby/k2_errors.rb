module K2ConnectRuby
  # Custom Errors
  class K2Errors < StandardError;
    # For cases where the access token is not equal to the one provided at K2ConnectRuby::K2Subscribe.token_request()
    class K2AccessTokenError < K2Errors
      def message
        STDERR.puts("Invalid Access Token!")
        exit(false )
      end
    end

    # For cases where the access token is nil/null/empty.
    class K2NilAccessToken < K2Errors
      def message
        STDERR.puts("No Access Token Created!")
        exit(false )
      end
    end

    # For cases where the access token has expired.
    class K2ExpiredToken < K2Errors
      def message?
        STDERR.puts("Expired Access Token.")
        return false
      end
    end

    # Raises an error should the body argument be empty
    class K2NilRequestBody < K2Errors
      def message
        STDERR.puts("Nil Request Body Argument!")
        exit(false )
      end
    end

    # Raises an error should the empty arguments for authentication
    class K2NilAuthArgument < K2Errors
      def message
        STDERR.puts("Nil Authentication Argument!\nCheck for Nil/Null Input in either your Secret Key, Signature or Request Body.")
        exit(false )
      end
    end

    # Raises error concerning a nil request Input in the parse_request or for method
    class K2NilRequest < K2Errors
      def message
        STDERR.puts("Nil Request Parameter Input!")
        exit(false )
      end
    end
  end

end