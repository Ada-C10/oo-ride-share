require 'csv'
require 'time'
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
        passenger_num = raw_trip[:passenger_id].to_i
        passenger = find_passenger(passenger_num)
        driver_number = raw_trip[:driver_id].to_i
        #binding.pry
        driver = find_driver(driver_number)
        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i,
          driver: driver
        }

        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip)
        driver.add_driven_trip(trip)
        trips << trip

      end

      return trips
    end

    def load_drivers(filename)
      drivers = []
      CSV.read(filename, headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:vin] = line[1]
        input_data[:status] = line[2].to_sym

        if find_passenger(input_data[:id]) != nil
          passenger = find_passenger(input_data[:id])
          input_data[:name] = passenger.name
          input_data[:phone_num] = passenger.phone_number
        end
        driver  = Driver.new(input_data)
        @passengers = passengers.map do |passenger|
          if passenger.id == driver.id
            driver
          else
            passenger
          end
        end

        drivers << driver
      end

      drivers

    end

    def find_passenger(id)
      check_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def available_driver
      return @drivers.find {|driver| driver.status == :AVAILABLE}
    end

    def request_trip(user_id)
      driver = available_driver
      start_time = Time.now
      end_time = nil
      trip_id = @trips.length + 1
      passenger = find_driver(user_id)
      new_trip = Trip.new({driver: driver, start_time: start_time, end_time: end_time, passenger: passenger, id: trip_id})
      driver.driven_trips << new_trip
      passenger.trips << new_trip
      @trips << new_trip
      driver.status = :UNAVAILABLE

      return new_trip

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
