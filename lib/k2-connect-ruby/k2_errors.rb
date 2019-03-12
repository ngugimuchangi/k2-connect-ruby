# Standard K2Error
class K2Errors < StandardError
  attr_reader :status, :error, :message
  def initialize(msg = @message)
    super(msg)
  end
end

# For errors concerning the Status code returned from Kopo Kopo
class K2ConnectionError < K2Errors
  def initialize(error)
    @error = error
  end

  def print_error
    case @error
    when 400.to_s
      raise ArgumentError.new("Bad Request.\n\tYour request is Invalid")
    when 401.to_s
      raise ArgumentError.new("Unauthorized.\n\tYour API key is wrong")
    when 403.to_s
      raise ArgumentError.new("Forbidden.\n\tThe resource requested cannot be accessed")
    when 404.to_s
      raise ArgumentError.new("Not Found.\n\tThe specified resource could not be found")
    when 405.to_s
      raise ArgumentError.new("Method Not Allowed.\n\tYou tried to access a resource with an invalid method")
    when 406.to_s
      raise ArgumentError.new("Not Acceptable.\n\tYou requested a format that isn't valid json")
    when 410.to_s
      raise ArgumentError.new("Gone.\n\tThe resource requested has been moved")
    when 429.to_s
      raise ArgumentError.new("Too Many Requests.\n\tRequest threshold has been exceeded")
    when 500.to_s
      raise ArgumentError.new("Internal Server Error.\n\tWe had a problem with our server. Try again later")
    when 503.to_s
      raise ArgumentError.new("Service Unavailable.\n\tWe're temporarily offline for maintenance. Please try again later")
    else
      raise ArgumentError.new('Undefined Kopo Kopo Server Response.')
    end
  end
end

# Errors concerning the Validation module
class K2ValidateErrors < K2Errors
  attr_reader :the_keys

  def initialize(the_keys)
    super
    @error = 400
    @the_keys = the_keys
    @status = :bad_request
  end

  def loop_keys
    STDERR.puts @message
    @the_keys.each(&method(:puts))
  end

  def message
    loop_keys
  end
end

# Hash / Params has Empty Values within it
class K2EmptyParams < K2ValidateErrors
  def initialize(the_keys)
    @message = "Invalid Hash Object!\n The Following Parameter(s) are Empty: "
    super
  end
end

# Error for Incorrect Hash Key Symbols (K2Entity validate => input)
class K2IncorrectParams < K2ValidateErrors
  def initialize(the_keys)
    @message = "Incorrect Hash/Parameters Object!\n The Following Parameter(s) are Incorrect: "
    super
  end
end
