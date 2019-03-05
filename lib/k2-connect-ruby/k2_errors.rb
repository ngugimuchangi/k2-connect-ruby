# TODO take a look at the last two errors. See if you can simplify the way the message can print without the loop in effect
# Standard K2Error
class K2Errors < StandardError
  attr_reader :status, :error, :message, :the_keys

  def loop_keys
    @the_keys.each_value(&method(:puts))
  end

  def message
    STDERR.puts(@message)
    loop_keys
  end

end

# Hash / Params has Empty Values within it
class K2InvalidHash < K2Errors
  def initialize (the_keys)
    @error = 400
    @the_keys  = the_keys
    @status = :bad_request
    @message = "Incorrect Hash Object!\n The Following Params are Empty: "
  end
end

# Error for Empty Hash Objects (K2Entity validate => input)
class IncorrectParams < K2Errors
  def initialize (the_keys)
    @error = 400
    @the_keys  = the_keys
    @status = :bad_request
    @message = "Incorrect Hash Parameters!\n The Following Params are Incorrect: "
  end
end