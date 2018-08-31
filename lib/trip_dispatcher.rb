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
      @passengers = load_users(user_file) #before this is the passengers from Users array and we want to add Driver info to the Users
      @drivers = load_drivers(driver_file)
      @trips = load_trips(trip_file)
    end

    def load_users(filename)
      # array of all user data
      users = []
      # goes through each line of csv file creates a hash and populates it with data
      # then uses class User to create instance of user for each line
      CSV.read(filename, headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:phone] = line[2]
        #the below two should be coming from drivers.csv
        # input_data[:vin] = line[1]
        # input_data[:status] = line[2]
        users << User.new(input_data)
      end
      return users
    end

    def load_drivers(filename)
      drivers = []

      CSV.read(filename, headers: true).each do |line|
        input_data = {}

        user = find_passenger(line[0].to_i)

        input_data[:id] = user.id
        input_data[:name] = user.name
        input_data[:phone] = user.phone_number

        input_data[:vin] = line[1]
        input_data[:status] = line[2].to_sym


        drivers << Driver.new(input_data)

      end

      return drivers
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
            start_time: Time.parse(raw_trip[:start_time]), #currently value saved as string
            end_time: Time.parse(raw_trip[:end_time]),
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

      def find_driver(id)
        check_id(id)
        return @drivers.find { |driver| driver.id == id}
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

      def find_driver_by_availability
        @drivers.each do |driver|
          if driver.status == :AVAILBLE
            return driver
          end
        end
      end

      def request_trip(user_id)
        passenger = find_passenger(user_id)
        # if find_passenger(user_id) = nil user does not exist
        raise ArgumentError.new"The user id: #{user_id} does not exist" if user_id == nil
        driver = find_driver_by_availability
        new_trip = Trip.new({id:(@trips.length + 1), passenger:passenger, start_time: Time.now, end_time: nil, cost: nil, rating: nil, driver:driver})
        @trips << new_trip
        return new_trip
      end


      private

      def check_id(id)
        raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
      end

    end
  end
