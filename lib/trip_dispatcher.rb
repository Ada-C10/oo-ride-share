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
      # binding.pry
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
        # binding.pry
        @users << User.new(input_data)
      end
      return @users
      # binding.pry
    end


    def load_drivers(filename) # use add_driven_trips method here
      # load drivers, collect the instances
      # if driver id is user id
      # in the passenger array, replace the old information with the new combined info
      # users = load_users('./support/users.csv')
      drivers = []
      driver_users = []

      CSV.read(filename, headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:vin] = line[1]
        input_data[:status] = line[2]
        input_data[:driver_trips] = []

        driver_users << input_data
      end

      driver_users.each do |driver|
        user = find_passenger(driver[:id])


          driver1 = Driver.new({id: driver[:id], name: user.name, vin: driver[:vin], phone: user.phone_number, status: driver[:status].to_sym, driven_trips: []})
          # binding.pry
          drivers << driver1
          # binding.pry
        end

        return drivers
      end

      # load drivers, collect the instances
      # if driver id is user id
      # in the passenger array, replace the old information with the new combined info
      # users = load_users('./support/users.csv')
      #
      # driver = 3, 67382992873, status
      # user = 3, Joe Smith, 555-55555
      #
      # driver/user = 3, Joe Smith, 627281919, 555-5555, status
      #
      # passengers array = [ {id: 3, name: Joe Smith, vin: 9484832222, phone: 555-5555, status}, {id: 2, name: Joanna Smith, phone 555-5555} ]




    # Modify TripDispatcher#load_trips to store the start_time and end_time as Time instances
    def load_trips(filename) #WAVE 2 updating driver passengers
      trips = []
      trip_data = CSV.open(filename, 'r', headers: true,
                                          header_converters: :symbol)
binding.pry
      trip_data.each do |raw_trip|
        passenger = find_passenger(raw_trip[:passenger_id].to_i)
        #driver = find_driver(raw_trip[:driver_id].to_i)
binding.pry
        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          driver: driver,
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
      binding.pry
    end



    def find_passenger(id)
      check_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id) #finds the id that is in the drivers array
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
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
