require 'csv'
require 'time'
require 'pry'
require 'time'
require_relative 'user'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips, :driver

    def initialize(user_file = 'specs/test_data/users_test.csv',
                   trip_file = 'specs/test_data/trips_test.csv',
                    driver_file = 'specs/test_data/drivers_test.csv')
      @passengers = load_users(user_file)
      @drivers = load_drivers(driver_file)
      @trips = load_trips(trip_file)
    end

    # creates instances of users and saves them in @passangers
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
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:vin] = line[1]
        input_data[:status] = line[2].to_sym
        user_data = find_passenger(input_data[:id])
        input_data[:name] = user_data.name
        input_data[:phone_number] = user_data.phone_number
        input_data[:trips] = user_data.trips
        drivers << Driver.new(input_data)

      end

      return drivers

    end



    # creates instances of trips and saves them in @trips, AND
    # it adds each trip to its corresponding instance of passanger
    def load_trips(filename)
      trips = []
      trip_data = CSV.open(filename, 'r', headers: true,
                                          header_converters: :symbol)

      trip_data.each do |raw_trip|
        # finds the passanger in the instance of passagers (@passangers)
        passenger = find_passenger(raw_trip[:passenger_id].to_i)
        driver = find_driver(raw_trip[:driver_id].to_i)

        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i,
          driver_id: raw_trip[:driver_id].to_i,
          driver: driver
        }
        trip = Trip.new(parsed_trip)
        driver.add_driven_trip(trip)
        # it adds each trip to its corresponding instance of passanger
        # every instance of a passanger is saved in @passagers
        passenger.add_trip(trip)
        trips << trip
      end

      return trips
    end

    # helps find the instance of a passanger
    # it's send back to load trips which create isntances of trips
    def find_passenger(id)
      check_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
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
