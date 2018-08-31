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
        passenger = find_passenger(raw_trip[:passenger_id].to_i)
        driver = find_driver(raw_trip[:driver_id].to_i)

        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          driver: driver,
          # Modify load_trips to store the start_time and end_time
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }

        trip = Trip.new(parsed_trip)
        driver.add_trip(trip)
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

    # Load the Drivers from the support/drivers.csv file and
    # return a collection of Driver instances, note that drivers
    # can be passengers too! Replace the instance of User in the
    # passengers array with a corresponding instance of Driver
    def load_drivers(filename)
      # initialize drivers
      drivers = []
      # parse csv for drivers
       CSV.open(filename, 'r', headers: true).map do |line|
        id = line[0].to_i
        passenger = find_passenger(line[0].to_i)
        # puts "hey its guille"
        # puts line[1].length

        driver_data = Driver.new({id: line[0].to_i,
          name: passenger.name,
          phone_number: passenger.phone_number,
          trips: passenger.trips,
          vehicle_id: line[1],
          status: line[2]})
          drivers << driver_data
      end
      return drivers
    end

    def find_driver(id)
      check_id(id)
      # binding.pry
      return @drivers.find { |driver| driver.id == id }
    end

    def request_trip(user_id)
      passenger = find_passenger(user_id)

      driver = @drivers.find { |driver| driver.status == :AVAILABLE && driver.id != user_id }
      raise ArgumentError, 'No available drivers' if driver.nil?

      parsed_trip = {
        id: "id",
        passenger: user_id,
        driver: driver.id,
        # Modify load_trips to store the start_time and end_time
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      trip = Trip.new(parsed_trip)
      driver.add_trip_in_progress(trip)
      passenger.add_trip(trip)
      @trips << trip
      return trip
    end

    private

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end
  end
end
