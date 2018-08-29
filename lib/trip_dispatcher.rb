require 'csv'
require 'time'
require 'pry'

require_relative 'user'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv',
                   trip_file = 'support/trips.csv',
                   driver_file = 'support/drivers.csv')
      @passengers = load_users(user_file)
      @drivers = load_drivers(driver_file)
      @trips = load_trips(trip_file)

    end

    def load_users(filename)
      users = []

      CSV.read(filename, headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:phone] = line[2]

        users << User.new(input_data)
      end

      return users
    end

    def load_drivers(filename)

      drivers = []

      CSV.read(filename, headers: true).each do |line|
        found_passenger = find_passenger(line[0].to_i)

        new_driver = Driver.new(id: line[0].to_i, name: found_passenger.name, phone: found_passenger.phone_number, vin: line[1], status: line[2].to_sym, trips: found_passenger.trips)

        drivers << new_driver

        @passengers[@passengers.index(found_passenger)] = new_driver

      end

      return drivers

        #Load the Drivers from the support/drivers.csv file and return a collection of Driver instances, note that drivers can be passengers too! Replace the instance of User in the passengers array with a cooresponding instance of Driver
    end

    def find_driver(id)
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def load_trips(filename)
#This method should be updated to add a corresponding Driver to the trip instance.

      trips = []
      trip_data = CSV.open(filename, 'r', headers: true,
                                          header_converters: :symbol)

      trip_data.each do |raw_trip|
        passenger = find_passenger(raw_trip[:passenger_id].to_i)
        driver = find_driver(raw_trip[:driver_id].to_i)

        parsed_trip = {
          id: raw_trip[:id].to_i,
          driver: driver,
          passenger: passenger,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }

        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip)
        driver.add_driven_trip(trip)
        trips << trip
      end

      return trips
    end

    def find_passenger(id)
      check_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def inspect
      return "#<#{self.class.name}:0x#{self.object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end








    private

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end
  end
end

# USER_TEST_FILE   = 'specs/test_data/users_test.csv'
# TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
# DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'
#
# RideShare::TripDispatcher
