module K2Validation
  # Method for Validating the input itself
  def validate_input(the_input, the_array)
    if the_input.empty?
      raise K2EmptyInput.new
    else
      if the_input.is_a?(Hash)
        validate_hash(the_input,   the_array)
      else
        validate_id(the_input, the_array)
      end
    end
    return true
  rescue K2EmptyInput => k2
    puts(k2.message)
    return false
  rescue TypeError => te
    puts(te.message)
    return false
  rescue K2InvalidHash => k3
    puts(k3.message)
    return false
  rescue IncorrectParams => k4
    puts(k4.message)
    return false
  end

  # Validate the Hash Input Parameters
  def validate_hash(the_input, empty_keys = {}, invalid_keys = {}, the_array)
    nil_params(the_input, empty_keys) and return
    if empty_keys.empty?
      puts "No Nil or Empty Values in Hash."
      check_keys(the_input, invalid_keys, the_array)
      unless invalid_keys.empty?
        raise IncorrectParams.new(invalid_keys)
      end
    else
      raise K2InvalidHash.new(empty_keys)
    end
  end

  def check_keys(the_input, invalid_hash, the_array)
    the_input.each_key do |key|
      unless the_array.include?(key.to_s)
        invalid_hash[:"#{key}"] = key
      end
    end
  end

  # Nil or Empty Values in Hash
  def nil_params(the_input, times= 0, nil_keys)
    while times < the_input.select{|_,v| v.nil? || v == ""}.keys.length
      the_input.select{|_,v| v.nil? || v == ""}.each_key do |a|
        nil_keys[:"item#{times}"] = a
        times += 1
      end
    end
  end

  # Validate the ID
  def validate_id(the_input, the_array) end

end