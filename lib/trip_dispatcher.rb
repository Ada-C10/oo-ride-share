require 'csv'
require 'time'

require_relative 'user'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv',
                   trip_file = 'support/trips.csv',
                   driver_file = 'support/driver.csv')
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
        driver = find_driver(raw_trip[:driver_id].to_i)


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
        trips << trip
      end

      return trips
    end

    def load_drivers(filename)
      drivers = []

      driver_data = CSV.open(filename, "r", headers:true, header_converters: :symbol)

      driver_data.each do |raw_driver|

        # NOTE: ALL IDS ARE THE SAME (no repeats between driver and passenger)
        # parsed_driver = {
        #   id: raw_driver[:id].to_i,
        #   vehicle_id: raw_driver[:vin],
        #   status: raw_driver[:status].to_sym
        # }


        # # old code
        user_trip = find_trips(raw_driver[:id]).first
        user_trips = find_trips(raw_driver[:id])
        #
        parsed_driver = {
          id: raw_driver[:id].to_i,
          name: user_trip.passenger.name
          phone_number: user_trip.passenger.phone,
          trips: user_trips,
          vehicle_id: raw_driver[:vin],
          driven_trips: [],
          status: raw_driver[:status].to_sym,
          passenger: nil
        }

        driver = Driver.new(parsed_driver)
        # passenger.add_trip(trip)
        drivers << driver

      end
    end

    def find_trips(id)
      check_id(id)
      return @trips.select { |trip| trip.passenger.id == id }
    end


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
