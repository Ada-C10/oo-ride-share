require 'csv'
require 'time'
require "pry"

require_relative 'user'
require_relative 'trip'
require_relative 'driver'

DELAY_LIMIT = 15

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv',
      trip_file = 'support/trips.csv',
      driver_file = 'support/drivers.csv')
      @passengers = load_users(user_file) #array of all Users from users csv
      @drivers = load_drivers(driver_file) # array of all Drivers from drivers csv
      @trips = load_trips(trip_file) #array of all Trips from trips csv
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
      trip_data = CSV.open(filename, headers: true, header_converters: :symbol)

      trip_data.each do |raw_trip|
        driver = find_driver(raw_trip[:driver_id].to_i) #instance of Driver class
        passenger = find_passenger(raw_trip[:passenger_id].to_i) # instance of User class
        parsed_trip = {
          id: raw_trip[:id].to_i,
          driver: driver.id,
          passenger: passenger.id,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }

        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip) # User.add_trip(trip) adds to @trips []
        driver.add_driven_trip(trip) # Driver.add_trip(trip) adds to @trips []
        trips << trip # TripDispatcher.load_trips(filename) adds to trips [], which is returned by load_trips. init loads trips to TripDisp @trips
      end

      return trips
    end

    def load_drivers(filename)
      drivers = []

      CSV.read(filename, headers: true).each do |line|
        input_data = {}

        user = find_passenger(line[0].to_i)

        input_data[:id] = line[0].to_i
        input_data[:vehicle_id] = line[1]
        input_data[:status] = line[2].to_sym

        input_data[:name] = user.name
        input_data[:phone_number] = user.phone_number
        input_data[:trips] = []#user.trips

        drivers << Driver.new(input_data)
      end
      return drivers
    end

    def find_driver(id)
      check_id(id)
      found_driver = @drivers.find { |driver| driver.id == id } #instance of Driver class
      if found_driver == nil
        raise ArgumentError, "Searched for driver #{id} but none found"
      else
        return found_driver
      end
    end

    def available_driver(user_id)
      check_id(user_id)
      time_at_delay = Time.now
      begin
        available = @drivers.find { |driver|
          driver.status == :AVAILABLE && driver.id != user_id
        }
        if available == nil
          raise ArgumentError, "No drivers are currently available."
        else
          return available
        end
      rescue ArgumentError => exception
        delay = (Time.now - time_at_delay)
        if delay < DELAY_LIMIT
          puts "#{exception.message} Please wait. (current delay @ #{delay}" \
               " of #{DELAY_LIMIT})"
          sleep(5)
          retry # goes back to beginning of BEGIN block
        else
          puts "Sorry, all our drivers are on the road! Try again later."
          sleep(2)
          raise ArgumentError, "Sorry, all our drivers are on the road!" \
                               " Try again later."
        end
      end
    end

    def find_passenger(id)
      check_id(id)
      found_passenger = @passengers.find { |passenger| passenger.id == id }
      if found_passenger == nil
        raise ArgumentError, "Searched for passenger #{id} but none found"
      else
        return found_passenger
      end
    end

    def inspect
      return "#<#{self.class.name}:0x#{self.object_id.to_s(16)} \
      #{trips.count} trips, \
      #{drivers.count} drivers, \
      #{passengers.count} passengers>"
    end

    def request_trip(user_id)

      driver = available_driver(user_id)
      passenger = find_passenger(user_id)

      input = {}

      input[:id] = trips.length + 1,
      input[:driver] = driver.id,
      input[:passenger] = user_id,
      input[:start_time] = Time.now

      new_in_progress_trip = Trip.new(input)
      driver.status = :UNAVAILABLE

      passenger.add_trip(new_in_progress_trip) # User.add_trip(trip) adds to @trips []
      driver.add_driven_trip(new_in_progress_trip) # Driver.add_trip(trip) adds to @trips []

      trips << new_in_progress_trip

      return new_in_progress_trip
    end

    private

    def check_id(id)
      if id.nil? || id <= 0
        raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})"
      end
    end

  end
end
