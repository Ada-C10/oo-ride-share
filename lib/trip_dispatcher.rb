require 'csv'
require 'time'
require 'pry'

require_relative 'user'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv',
      trip_file = 'support/trips.csv', drivers_file = 'support/drivers.csv')

      @passengers = load_users(user_file) # [drivers & passengers]
      @trips = load_trips(trip_file)
      @drivers = load_drivers(drivers_file)
      replace_passenger(@passengers, @drivers)

    end

    # Replace the instance of User in the passengers array with a cooresponding instance of Driver

    def load_users(filename)
      users = []

      CSV.read(filename, headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:phone] = line[2]
        # match_driver_to_passengers(input_data[:id])

        users << User.new(input_data)

      end

      return users
    end

    def load_drivers(filename)
      drivers = []

      CSV.read(filename, headers: true, header_converters: :symbol).each do |line|

        user = find_passenger(line[:id].to_i) #change index to symbol        #what does it do if it can't fine a passenger/user

        driver_data = {}
        driver_data[:id] = user.id.to_i
        driver_data[:name] = user.name
        driver_data[:phone] = user.phone_number
        driver_data[:vin] = line[:vin]
        driver_data[:status] = line[:status].to_sym

        drivers << Driver.new(driver_data)

      end

      return drivers
    end


    # def match_driver_to_passengers(driver_id)
    #   total_users = []
    #   @drivers.each do |driver|
    #     if @passengers.include? driver[:id]
    #       passenger_info = find_passenger(driver[:id])
    #       driver.name = passenger_info[:name]
    #       driver.trips = passenger_info [:trips]
    #     else total_users << driver
    #     end
    #   end
    # end
    #
    # def create_total_users_array
    #   total_users= []
    #   @passengers.each do |passenger|
    #     if @drivers.include? passenger[:id]
    #       match_driver_to_passengers(driver_id)
    #     else total_users << passenger
    #   end
    #
    # end

    def replace_passenger(passenger_array, driver_array)

      driver_n_passengers = passenger_array.map do |passenger|
        driver_array.map do |driver|
          if passenger.id == driver.id
            passenger = driver
          end
        end
        passenger
      end

      passenger_array.replace(driver_n_passengers)

      return passenger_array
    end

    def load_trips(filename)
      trips = []
      trip_data = CSV.open(filename, 'r', headers: true, header_converters: :symbol)

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

    def find_passenger(id)
      check_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    # def find_driver(id)
    #   check_id(id)
    #   return @drivers.find { |driver| driver.id == id }
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
