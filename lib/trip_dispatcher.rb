require 'csv'
require 'time'
require 'awesome_print'
require 'pry'

require_relative 'user'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :trips
    attr_accessor :passengers

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

    def load_drivers(filename)
      drivers = []

      CSV.read(filename, headers: true).each do |line|
        drivers << Driver.new(id: line[0].to_i, vin: line[1], status: line[2].to_sym)
      end

      return drivers
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

        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip)
        trips << trip
      end

      return trips
    end

    def replace_passenger_with_driver
      @passengers.each_with_index do |user, i|
        @drivers.each do |driver|
          if driver.id == user.id
            user = Driver.new(id: user.id, name: user.name, vin: driver.vehicle_id, phone: user.phone_number, status: driver.status)
            @passengers[i] = user
          end
        end
      end
      ap @passengers
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

a = RideShare::TripDispatcher.new
a.replace_passenger_with_driver
