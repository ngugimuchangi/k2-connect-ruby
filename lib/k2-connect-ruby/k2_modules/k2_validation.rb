# TODO David Nino take a look at validate_input.
# Module for Validating Input to the Entities
module K2Validation
  # Method for Validating the input itself
  def validate_input(the_input, the_array, is_query)
    if the_input.empty?
      raise ArgumentError.new("Empty or Nil Input!\n No Input Content has been given.")
    else
      if is_query
        validate_id(the_input, the_array)
      else
        if the_input.is_a?(Hash)
          validate_hash(the_input, the_array)
        elsif the_input.has_key?(:authenticity_token)
        validate_hash(the_input.permit!.to_hash, the_array)
        else
          # Error
          "Undefined Input Form"
        end
      end
    end
    true
  end

  # Validate the Hash Input Parameters
  def validate_hash(the_input, empty_keys = HashWithIndifferentAccess.new, invalid_keys = HashWithIndifferentAccess.new, the_array)
    nil_params(the_input, empty_keys) and return
    if empty_keys.empty?
      puts "No Nil or Empty Values in Hash."
      check_keys(the_input, invalid_keys, the_array)
      unless invalid_keys.empty?
        raise IncorrectParams.new(invalid_keys)
      end
      true
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
  def validate_id(the_input, the_array)
    unless !!the_input==the_input
      "ID is not a Boolean"
      true
    end
  end

end