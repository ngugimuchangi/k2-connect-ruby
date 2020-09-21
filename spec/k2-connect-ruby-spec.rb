# Base
require 'spec_helper'
require 'k2_tests/k2-version-spec'

# Utilities
require 'k2_tests/utility_tests/k2_config_spec'
require 'k2_tests/utility_tests/k2_process_spec'
require 'k2_tests/utility_tests/k2_authorize_spec'
require 'k2_tests/utility_tests/k2_connection_spec'
require 'k2_tests/utility_tests/k2_validation_spec'

# Services
require 'k2_tests/service_tests/k2_results_spec'
require 'k2_tests/service_tests/results_spec/webhook_spec'
require 'k2_tests/service_tests/client_spec/k2_client_spec'
require 'k2_tests/service_tests/results_spec/k2_common_events_spec'

# Entity
require 'k2_tests/entity_tests/k2_token_spec'
require 'k2_tests/entity_tests/k2_entity_spec'
require 'k2_tests/entity_tests/k2_subscribe_spec'
require 'k2_tests/entity_tests/entities_spec/k2_pay_spec'
require 'k2_tests/entity_tests/entities_spec/k2_stk_spec'
require 'k2_tests/entity_tests/entities_spec/k2_transfer_spec'
require 'k2_tests/entity_tests/entities_spec/k2_settlement_spec'
