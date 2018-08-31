require 'time'
require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require 'awesome_print'
# Add simplecov

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'

# Require_relative your lib files here!
require_relative '../lib/user'
require_relative '../lib/trip'
require_relative '../lib/trip_dispatcher'
require_relative '../lib/driver'
