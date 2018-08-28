require 'csv'
require 'time'
require 'pry'
require_relative 'user'
require_relative 'trip'
require_relative 'driver'
require 'awesome_print'

# TODO DELETE THIS LATER - IS FOR TESTING CODE
USER_TEST_FILE   = 'support/users.csv'
TRIP_TEST_FILE   = 'support/trips.csv'
DRIVER_TEST_FILE = 'support/drivers.csv'


module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv',
                   trip_file = 'support/trips.csv',
                  driver_file = 'support/drivers.csv')
      @passengers = load_users(user_file)
      @trips = load_trips(trip_file)
      @drivers = load_drivers(driver_file)
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

        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }

        # binding.pry
        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip)
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

    def find_driver(id)
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    # Method to load drivers
    def load_drivers(filename)
      drivers = []

      # pull in drivers.csv and create Driver objects
      CSV.read(filename, headers: true).each do |line|
        driver_input_data = {}
        driver_input_data[:id] = line["id"].to_i
        driver_input_data[:vin] = line["vin"]
        driver_input_data[:status] = line["status"].to_sym
        drivers << Driver.new(driver_input_data)
        # binding.pry
      end

      # find the drivers' passenger data and add their
      # passenger info to their Driver object
      drivers.each do |driver|
        # Finding drivers user data based on id
        user = self.find_passenger(driver.id)
        # Assigning driver information based on user
        if user
          driver.name = user.name
          driver.phone_number = user.phone_number
          driver.trips = user.trips
        end
        # Swapping out passenger with driver
        @passengers[@passengers.index(user)] = driver
      end
      return drivers
    end

    # Method to find drivers
    def find_driver(id)
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end

    private
  end
end


dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE)


binding.pry
