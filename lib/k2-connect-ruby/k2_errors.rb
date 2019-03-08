# Standard K2Error
class K2Errors < StandardError
  attr_reader :status, :error, :message
  def initialize(msg=@message)
    super(msg)
  end
end

class K2ConnectionError < K2Errors
  def initialize(error)
    @error = error
  end

  def print_error
    if @error.to_s.eql?(400.to_s)
      @message = "Bad Request.\n\tYour request is Invalid"
    elsif @error.to_s.eql?(401.to_s)
      @message =  "Unauthorized.\n\tYour API key is wrong"
    elsif @error.to_s.eql?(403.to_s)
      @message =  "Forbidden.\n\tThe resource requested cannot be accessed"
    elsif @error.to_s.eql?(404.to_s)
      @message =  "Not Found.\n\tThe specified resource could not be found"
    elsif @error.to_s.eql?(405.to_s)
      @message =  "Method Not Allowed.\n\tYou tried to access a resource with an invalid method"
    elsif @error.to_s.eql?(406.to_s)
      @message =  "Not Acceptable.\n\tYou requested a format that isn't valid json"
    elsif @error.to_s.eql?(410.to_s)
      @message = "Gone.\n\tThe resource requested has been moved"
    elsif @error.to_s.eql?(429.to_s)
      @message = "Too Many Requests.\n\tRequest threshold has been exceeded"
    elsif @error.to_s.eql?(500.to_s)
      @message = "Internal Server Error.\n\tWe had a problem with our server. Try again later"
    elsif @error.to_s.eql?(503.to_s)
      @message = "Service Unavailable.\n\tWe're temporarily offline for maintenance. Please try again later"
    end
  end
end

# Errors pertaining to Validation  module
class K2ValidateErrors < K2Errors
  attr_reader :the_keys

  def initialize (the_keys)
    super
    @error = 400
    @the_keys  = the_keys
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
  def initialize (the_keys)
    @message = "Invalid Hash Object!\n The Following Parameter(s) are Empty: "
    super
  end
end

# Error for Incorrect Hash Key Symbols (K2Entity validate => input)
class K2IncorrectParams < K2ValidateErrors
  def initialize (the_keys)
    @message = "Incorrect Hash/Parameters Object!\n The Following Parameter(s) are Incorrect: "
    super
  end
end
