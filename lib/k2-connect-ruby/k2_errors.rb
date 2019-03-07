# Standard K2Error
class K2Errors < StandardError
  attr_reader :status, :error, :message

end

# Errors pertaining to Validation  module
class K2ValidateErrors < K2Errors
  attr_reader :the_keys

  def initialize (the_keys)
    @error = 400
    @the_keys  = the_keys
    @status = :bad_request
  end

  def loop_keys
    @the_keys.each_value(&method(:puts))
  end

  def message
    STDERR.puts(@message)
    loop_keys
  end

end

# Hash / Params has Empty Values within it
class K2InvalidHash < K2ValidateErrors
  def initialize (the_keys)
    @message = "Incorrect Hash Object!\n The Following Params are Empty: "
  end
end

# Error for Incorrect Hash Key Symbols (K2Entity validate => input)
class IncorrectParams < K2ValidateErrors
  def initialize (the_keys)
    @message = "Incorrect Hash Parameters!\n The Following Params are Incorrect: "
  end
end
