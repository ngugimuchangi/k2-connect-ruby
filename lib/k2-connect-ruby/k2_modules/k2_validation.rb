# TODO David Nino take a look at validate_id.
# Module for Validating Input to the Entities
module K2Validation
  # Method for Validating the input itself
  def validate_input(the_input, the_array)
    if the_input.blank?
      raise ArgumentError.new("Empty or Nil Input!\n No Input Content has been given.")
    else
      unless !!the_input==the_input
        if the_input.is_a?(Hash)
          validate_hash(the_input, the_array)
        else
          begin
            if the_input.has_key?(:authenticity_token)
              validate_hash(the_input.permit!.to_hash, the_array)
            else
              raise ArgumentError.new("Undefined Input Format.\n The Input is Neither a Hash nor a Parameter Object.")
            end
          rescue NoMethodError => nme
            if nme.message.include?("has_key?")
              raise ArgumentError.new("Undefined Input Format.\n The Input is Neither a Hash nor a Parameter Object.")
            end
          end
        end
      end
    end
    true
  end

  # Validate the Hash Input Parameters
  def validate_hash(the_input, empty_keys = HashWithIndifferentAccess.new, invalid_keys = HashWithIndifferentAccess.new, the_array)
    nil_params(the_input, empty_keys) and return
    if empty_keys.blank?
      check_keys(the_input, invalid_keys, the_array)
      unless invalid_keys.blank?
        raise IncorrectParams.new(invalid_keys)
      end
      true
    else
      raise K2InvalidHash.new(empty_keys)
    end
  end

  # Find  Incorrect Hash Keys or Symbols in Hash
  def check_keys(the_input, invalid_hash, the_array)
    the_input.each_key do |key|
      unless the_array.include?(key.to_s)
        invalid_hash[:"#{key}"] = key
      end
    end
  end

  # Find  Nil or Empty Values in Hash
  def nil_params(the_input, times= 0, nil_keys)
    while times < the_input.select{|_,v| v.blank?}.keys.length
      the_input.select{|_,v| v.blank?}.each_key do |a|
        nil_keys[:"item#{times}"] = a
        times += 1
      end
    end
  end

end