require 'csv'
require 'time'
require 'ap'
require 'pry'

require_relative 'user'
require_relative 'trip'
require_relative 'driver'

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


    def load_trips(filename)
      trips = []
      trip_data = CSV.open(filename, 'r', headers: true,
                                          header_converters: :symbol)

      trip_data.each do |raw_trip|
        passenger = find_passenger(raw_trip[:passenger_id].to_i)
        driver = find_driver(raw_trip[:driver_id].to_i)

        # #NOTE: WHY DON'T THESE TWO LINES WORK THO?
        start_time = Time.parse(raw_trip[:start_time])
        end_time = Time.parse(raw_trip[:end_time])

        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          start_time: start_time,
          end_time: end_time,
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i,
          driver: driver
        }

        trip = Trip.new(parsed_trip)


        passenger.add_trip(trip)
        # driver.add_trip(trip)
        driver.add_driven_trip(trip)
        trips << trip

      end

      return trips
    end

    def load_drivers(filename)
      drivers = []

      driver_data = CSV.open(filename, "r", headers:true, header_converters: :symbol)

      driver_data.each do |raw_driver|

        # NOTE: ALL IDS ARE THE SAME (no repeats between driver and passenger)

        user = find_passenger(raw_driver[:id].to_i)

        # binding.pry

        parsed_driver = {
          id: raw_driver[:id].to_i,
          name: user.name,
          phone: user.phone_number,
          vin: raw_driver[:vin],
          status: raw_driver[:status].to_sym
        }

        driver = Driver.new(parsed_driver)
        drivers << driver
      end
      return drivers
    end

    def find_passenger(id)
      check_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def request_trip(user_id)
      current_passenger = find_passenger(user_id)
      available_driver = @drivers.find { |driver| driver.status == :AVAILABLE }

      ap available_driver.status

      available_driver.status = :UNAVAILABLE

      ap available_driver.status

      parsed_trip = {
        id: @trips.length + 1,
        passenger: current_passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: available_driver
      }


      trip_in_progress = Trip.new(parsed_trip)
      current_passenger.add_trip(trip_in_progress)
      available_driver.add_driven_trip(trip_in_progress)
      @trips << trip_in_progress

      return trip_in_progress
    end

    def inspect
      return "#<#{self.class.name}:0x#{self.object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    private

    def check_id(id)
      id = id.to_i
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
      return id
    end
  end
end


# pass = RideShare::User.new(id: 1, name: "Ada", phone: "412-432-7640")
# driver_1 = RideShare::Driver.new(id: 3, name: "Stella", vin: "12345678912345678", status: :AVAILABLE)
# driver_2 = RideShare::Driver.new(id: 4, name: "Bernie", vin: "12345678912345679", status: :AVAILABLE)
#
# trip = RideShare::Trip.new({id: 8, passenger: pass, start_time: "2016-08-08T12:14:00+00:00", end_time: "2018-05-20T12:14:00+00:00",  cost: 55, rating: 5, driver: driver_1})

# #
# USER_TEST_FILE   = 'specs/test_data/users_test.csv'
# TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
# DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'
# #
# # # # ap pass
# ride = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)
# pass =  ride.passengers
# #
# # #
# # # pass.each do |passenger|
# # #   ap passenger.name
# # # end
# # #
# # # # ap ride.check_id(2)
# # # ap ride.find_passenger(2)
# ap ride.drivers

# ap ride.passengers
# ap ride.drivers
# ap ride.trips


# ap ride.load_trips
# ap ride.load_drivers
# #
# trip_data = CSV.open('support/users.csv', 'r', headers: true,
#                                     header_converters: :symbol)
#
# trip_data.each do |line|
#   ap line
# end


# TODO:
# write tests for Wave 3
# edge case tests? thorough testing
# write conditionals for nil values)
# use LET with our test code
# Refactor/clean up tabs/take out test code
# Comprehension questions

# ap trip.start_time.class

# ap trip.calculate_trip_duration


# USER_TEST_FILE   = 'specs/test_data/users_test.csv'
# TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
# DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'
#
# hello = RideShare::TripDispatcher.new()
# #
# ap hello


# changes to_i in raw[:id] line 83
