# Module for Validating Input
module K2Validation
  # Validating Method
  def validate_input(the_input, the_array)
    if the_input.blank?
      raise ArgumentError.new("Empty or Nil Input!\n No Input Content has been given.")
    else
      unless !!the_input == the_input
        if the_input.is_a?(Hash) || the_input.is_a?(HashWithIndifferentAccess)
          the_input = the_input.with_indifferent_access
          validate_hash(the_input, the_array)
        else
          begin
            if the_input.has_key?(:authenticity_token)
              the_input = the_input.permit(the_array).to_hash.with_indifferent_access
              nil_values(the_input)
            else
              raise ArgumentError.new("Undefined Input Format.\n The Input is Neither a Hash nor a ActionController::Parameter Object.")
            end
          rescue NoMethodError => nme
            if nme.message.include?("has_key?")
              raise ArgumentError.new("Undefined Input Format.\n The Input is Neither a Hash nor a ActionController::Parameter Object.")
            end
          end
        end
      end
    end
  end

  # Validate the Hash Input Parameters
  def validate_hash(the_input, the_array)
    nil_values(the_input)
    incorrect_keys(the_input, the_array)
  end

  # Return Incorrect Key Symbols for Hashes
  def incorrect_keys(the_input, invalid_hash = Array.new, the_array)
    the_input.each_key do |key|
      unless the_array.include?(key.to_s)
        invalid_hash << key
      end
    end
    raise K2IncorrectParams.new(invalid_hash) if invalid_hash.present?
    true
  end

  # Return Key Symbols with Blank Values
  def nil_values(the_input, nil_keys_array = Array.new)
      the_input.select { |_, v| v.blank? }.each_key do |key|
        nil_keys_array << key.to_s
      end
      raise K2EmptyParams.new(nil_keys_array) unless nil_keys_array.blank?
      true
    end

  # Validate Phone Number
  def validate_phone(phone)
    # Kenyan Phone Numbers
    if phone[-(number = phone.to_i.to_s.size).to_i, 3].eql?(254.to_s)
      raise ArgumentError.new('Invalid Phone Number.') unless phone[-9, 9][0].eql?(7.to_s)
    else
      raise ArgumentError.new('Invalid Phone Number.') unless number.eql?(9)
    end
    phone.tr('+', '')
  end

  # Validate Email Format
  def validate_email(email)
    raise ArgumentError.new('Invalid Email Address.') unless email.match(URI::MailTo::EMAIL_REGEXP).present?
    email
  end
  #
  # def convert_params(params)
  #   params.with_indifferent_access
  # end
end


# Trash Code
#
# Validate the Hash Input Parameters
# def validate_hash(the_input, empty_keys = Array.new, invalid_keys = Array.new, the_array)
#   nil_values(the_input, empty_keys)
#   raise K2EmptyParams.new(empty_keys) if empty_keys.present?
#   incorrect_keys(the_input, invalid_keys, the_array)
#   raise K2IncorrectParams.new(invalid_keys) if invalid_keys.present?
#   true
# end