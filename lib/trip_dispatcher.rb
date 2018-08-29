require 'csv'
require 'time'
require 'pry'

require_relative 'user'
require_relative 'trip'


module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips
    attr_writer :passengers

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

        parsed_trip = {
          id: raw_trip[:id].to_i,
          driver_id: find_driver(raw_trip[:driver_id].to_i),
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

    #Changes this method that finds the passenger and creates the driver with the info from that AND the driver data,
    #The other way we were doing it was not working because it was totally replacing what was there
    #when we really want to combine the two....
    # def load_drivers(filename)
    #   drivers = []
    #
    #   CSV.read(filename, headers: true).each do |line|
    #     passenger = find_passenger(line[0].to_i)
    #     drivers << Driver.new(id:line[0].to_i, name: passenger.name, phone: passenger.phone_number, vin:line[1], status:line[2].to_sym, trips: passenger.trips)
    #   end
    #
    #   return drivers
    # end
    def load_drivers(filename)
      drivers = []
      drivers_data = CSV.open(filename,'r', headers: true, header_converters: :symbol)
        drivers_data.each do |raw_data|
          #use find passenger method to say the driver is equal to this passenger
          driver = find_passenger(raw_data[:id].to_i)
          parsed_driver = {id: raw_data[:id].to_i, vechicle_id: raw_data[:vin], status: raw_data[:status].to_sym, name: driver.name, phone:driver.phone}
          driver = Driver.new(parsed_driver)
#this can be used with add_driven_trip to add trips to drivers
          @trips.each do |trip|
            if trip.driver.id == driver.id
              driver.add_driven_trip(trip)
            end
          end
          drivers << driver
      end
      return drivers
    end


    def find_driver(id)
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
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

    # # @passengers = [...]
    # # @drivers = [...]
    # def replace_passengers_with_drivers!
    #   @passengers.map! do |passenger|
    #     driver = find_driver(passenger.id)
    #     # if driver
    #     #   driver
    #     # else
    #     #   passenger
    #     # end
    #
    #     driver || passenger
    #   end
    # end
  end
end
