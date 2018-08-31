require 'csv'
require 'time'


require_relative 'user'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv', trip_file = 'support/trips.csv',
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
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i,
          driver: driver

        }

        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip)
        driver.add_trip(trip)

        trips << trip
      end

      return trips
    end


    def load_drivers(filename)
      drivers = []

      driver_data = CSV.open(filename, 'r', headers: true, header_converters: :symbol)

      driver_data.each do |driver|

        input = {}
        input[:id] = driver[0].to_i
        input[:vin] = driver[1]
        input[:status] = driver[2].to_sym
        input[:name] = find_passenger(input[:id]).name
        input[:phone_number] = find_passenger(input[:id]).phone_number

        drivers << Driver.new(input)
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

    #test -- dispatcher.request_trip
    #in code


    def request_trip(user_id)

      passenger = find_passenger(user_id)
      driver = @drivers.find { |driver| driver.status == :AVAILABLE }

      start_time = Time.now
    id = @trips.length + 1

      trip_hash = {
        id: id,
        passenger: passenger,
        driver: driver,
        start_time: start_time,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      new_trip = RideShare::Trip.new(trip_hash)

      #make driver unavailable first
      driver.update_status

      passenger.add_trip(new_trip)
      driver.add_driven_trip(new_trip)
      @trips << new_trip

    return new_trip
    end


    private

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end
  end
end
