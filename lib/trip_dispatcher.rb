require 'csv'
require 'time'
require_relative 'user'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv', trip_file = 'support/trips.csv', driver_file = 'support/drivers.csv')
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
      trip_data = CSV.open(filename, 'r', headers: true, header_converters: :symbol)

      trip_data.each do |raw_trip|
        passenger = find_passenger(raw_trip[:passenger_id].to_i)
        driver = find_driver(raw_trip[:driver_id].to_i)
        time_start = Time.parse(raw_trip[:start_time])
        time_end = Time.parse(raw_trip[:end_time])

        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          start_time: time_start,
          end_time: time_end,
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i,
          driver: driver
        }

        time_check = parsed_trip[:start_time] <=> parsed_trip[:end_time]
        if time_check > 0
          raise ArgumentError, "Start time is after end time!"
        end

        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip)
        driver.add_driven_trip(trip)
        trips << trip
      end
      return trips
    end

    def load_drivers(filename)
      drivers = []
      driver_data = CSV.read(filename, 'r', headers: true, header_converters: :symbol)

      driver_data.each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:name] = find_passenger(line[0].to_i).name
        input_data[:phone] = find_passenger(line[0].to_i).phone_number
        input_data[:vin] = line[1]
        input_data[:status] = line[2].to_sym
        drivers << Driver.new(input_data)
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

    def inspect
      return "#<#{self.class.name}:0x#{self.object_id.to_s(16)} \
      #{trips.count} trips, \
      #{drivers.count} drivers, \
      #{passengers.count} passengers>"
    end

    def find_available_driver
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          return driver
        end
      end
      return nil
    end

    def request_trip(user_id)
      driver = find_available_driver
      passenger = find_passenger(user_id)
      driver == nil ? (return nil) : driver

      if passenger.id == driver.id
        raise ArgumentError.new
      end

      input = {
        id: @trips.length + 1,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: driver
      }
      trip = Trip.new(input)

      driver.accept_trip(trip)
      find_passenger(user_id).add_trip(trip)
      @trips << trip
      return trip
    end

    private

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end

  end
end
