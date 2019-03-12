# Base
require 'k2-connect-ruby/k2_errors'
require 'k2-connect-ruby/version'
require 'active_support/json'
# For the blank? check
require 'active_support/dependencies/autoload'
require 'active_support/core_ext'

# Modules
require 'k2-connect-ruby/modules'

# Services
require 'k2-connect-ruby/k2_services/k2_results'
require 'k2-connect-ruby/k2_services/results'

# Entity
require 'k2-connect-ruby/k2_entity/k2_entity'
require 'k2-connect-ruby/k2_entity/entity'

# ActiveSupport
require 'active_support/core_ext/hash/indifferent_access'

=begin
 TODO, Friday meeting:
    Solve the Issue for Subscription Class and Error for STK, PAY and Transfer.
    Errors for Invalid/Empty Params can be Argument Errors, but create a class for Looping through the Keys.
=end
