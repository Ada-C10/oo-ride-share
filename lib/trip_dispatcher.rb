require 'csv'
require 'time'
require 'awesome_print'
require 'pry'

require_relative 'user'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv',
                   trip_file = 'support/trips.csv', driver_file = 'support/drivers.csv')
      @passengers = load_users(user_file)
      @trips = load_trips(trip_file)
      @drivers =  load_drivers(driver_file)
    end

    def load_users(filename)
      @users = []

      CSV.read(filename, headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:phone] = line[2]

        @users << User.new(input_data)
      end

      return @users
    end


    def load_drivers(filename)
      # load drivers, collect the instances
      # if driver id is user id
      # in the passenger array, replace the old information with the new combined info
      # users = load_users('./support/users.csv')
      # binding.pry
      @drivers = []
      driver_users = []

      CSV.read('support/drivers.csv', headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:vin] = line[1]
        input_data[:status] = line[2]

        @drivers << input_data
      end



        @drivers.each do |driver|
        user = find_passenger(driver[:id])
          driver_users << {id: user[:id], name: user[:name], vin: driver[:vin], phone: user[:phone], status: driver[:status]}
        end



      return driver_users
      end

      #
      #
      # driver = 1, 67382992873, status
      # user = 1, Joe Smith, 555-55555
      #
      # driver/user = 1, Joe Smith, 627281919, 555-5555
      #
      # passengers array = [ {id: 1, name: Joe Smith, vin: 9484832222, phone: 555-5555, status}, {id: 2, name: Joanna Smith, phone 555-5555} ]




    # Modify TripDispatcher#load_trips to store the start_time and end_time as Time instances
    def load_trips(filename) #WAVE 2 update to add Driver to trip instance
      trips = []
      trip_data = CSV.open(filename, 'r', headers: true,
                                          header_converters: :symbol)

      trip_data.each do |raw_trip|
        passenger = find_passenger(raw_trip[:passenger_id].to_i)

        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          start_time: Time.parse(raw_trip[:start_time]), # rawtrip hash start_time in new_hash parsed_trip
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

    def find_passenger(id)
      check_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    # def find_driver(id)
    # end

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
