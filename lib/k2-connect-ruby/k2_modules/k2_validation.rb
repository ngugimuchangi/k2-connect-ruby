# Module for Validating Input
# TODO: Correct validation of url so that it only accepts https
module K2Validation
  # Validating Method
  def validate_input(the_input, the_array)
    if the_input.blank?
      raise ArgumentError, "Empty or Nil Input!\n No Input Content has been given."
    else
      unless !!the_input == the_input
        if the_input.is_a?(Hash)
          validate_hash(the_input.with_indifferent_access, the_array)
        else
          begin
            if the_input.is_a?(String)
              raise ArgumentError, "Wrong Input Format.\n The Input is a String."
            elsif the_input.is_a?(Integer)
              raise ArgumentError, "Wrong Input Format.\n The Input is an Integer."
            elsif the_input.key?(:authenticity_token)
              nil_values(the_input.permit(the_array).to_hash.with_indifferent_access)
            else
              raise ArgumentError, "Undefined Input Format.\n The Input is Neither a Hash nor an ActionController::Parameter Object."
            end
          rescue NoMethodError => nme
            if nme.message.include?('has_key?')
              raise ArgumentError, "Undefined Input Format.\n The Input is Neither a Hash nor an ActionController::Parameter Object."
            end
          end
        end
      end
    end
    to_indifferent_access(the_input)
  end

  # Validate the Hash Input Parameters
  def validate_hash(the_input, the_array)
    nil_values(the_input)
    incorrect_keys(the_input, the_array)
  end

  # Return Incorrect Key Symbols for Hashes
  def incorrect_keys(the_input, invalid_hash = [], the_array)
    the_input.each_key do |key|
      invalid_hash << key unless the_array.include?(key.to_s)
    end
    raise K2IncorrectParams, invalid_hash if invalid_hash.present?
  end

  # Return Key Symbols with Blank Values
  def nil_values(the_input, nil_keys_array = [])
    the_input.select { |_, v| v.blank? }.each_key do |key|
      nil_keys_array << key.to_s
    end
    raise K2EmptyParams, nil_keys_array unless nil_keys_array.blank?
  end

  # Validate Phone Number
  def validate_phone(phone)
    # Kenyan Phone Numbers
    unless phone.blank?
      if phone[-(number = phone.to_i.to_s.size).to_i, 3].eql?(254.to_s)
        raise ArgumentError, 'Invalid Kenyan Phone Number.' unless phone[-9, 9][0].eql?(7.to_s)
      else
        raise ArgumentError, 'Invalid Phone Number.' unless number.eql?(9)
      end
      phone.tr('+', '')
    end
  end

  # Validate Email Format
  def validate_email(email)
    unless email.blank?
      raise ArgumentError, 'Invalid Email Address.' unless email.match(URI::MailTo::EMAIL_REGEXP).present?
    end
    email
  end

  # Converts Hash Objects to HashWithIndifferentAccess Objects
  def to_indifferent_access(params)
    if params.is_a?(Hash)
      params.with_indifferent_access
    else
      params
    end
    params
  end

  def validate_url(url)
    raise ArgumentError, 'Invalid URL Format.' unless url =~ /\A#{URI.regexp(%w[https http])}\z/
    #raise ArgumentError, 'Invalid URL Format.' unless url =~ /\A#{URI.regexp(%w[https])}\z/
    url
  end
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
