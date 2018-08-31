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
        users << User.new({:id => line[0].to_i, :name => line[1], :phone => line[2]})
      end

      return users
    end

    def load_drivers(filename)
      drivers = []

      CSV.read(filename, headers: true).each do |line|
        found_passenger = find_passenger(line[0].to_i)

        new_driver = Driver.new(id: line[0].to_i,
                                name: found_passenger.name,
                                phone: found_passenger.phone_number,
                                vin: line[1],
                                status: line[2].to_sym,
                                trips: found_passenger.trips)

        drivers << new_driver
        @passengers[@passengers.index(found_passenger)] = new_driver
      end

      return drivers
    end

    def find_driver(id)
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def load_trips(filename)
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

    def request_trip(user_id)
      available_drivers = @drivers.select {|driver| driver.status == :AVAILABLE and driver.id != user_id }

      driver = available_drivers.find {|driver| driver.driven_trips.empty?}

      # first find the latest trip end time for each driver, then find the driver associated with the least recent trip end time
      driver ||= available_drivers.min_by {|driver|
        latest_trip = driver.driven_trips.max_by {|trip| trip.end_time}
        latest_trip.end_time}

      raise ArgumentError, 'No drivers available' if driver == nil

      passenger = find_passenger(user_id)

      input = {
        id: @trips.last.id + 1,
        driver: driver,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      new_trip = Trip.new(input)
      @trips << new_trip

      driver.make_unavailable
      driver.add_driven_trip(new_trip)

      passenger.add_trip(new_trip)

      return new_trip
    end

    private

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end
  end
end
