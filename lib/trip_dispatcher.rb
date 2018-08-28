require 'csv'
require 'time'
require 'pry'

require_relative 'user'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv',
                   trip_file = 'support/trips.csv')
      @passengers = load_users(user_file)
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

    # creates instances of trips and saves them in @trips, AND
    # it adds each trip to its corresponding instance of passanger
    def load_trips(filename)
      trips = []
      trip_data = CSV.open(filename, 'r', headers: true,
                                          header_converters: :symbol)

      trip_data.each do |raw_trip|
        # finds the passanger in the instance of passagers (@passangers)
        passenger = find_passenger(raw_trip[:passenger_id].to_i)

        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          start_time: raw_trip[:start_time],
          end_time: raw_trip[:end_time],
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }
        binding.pry
        trip = Trip.new(parsed_trip)
        # it adds each trip to its corresponding instance of passanger
        # every instance of a passanger is saved in @passagers
        passenger.add_trip(trip)
        binding.pry
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
