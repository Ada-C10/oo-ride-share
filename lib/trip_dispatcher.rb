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

    def load_drivers(filename)
      drivers = []

      CSV.read(filename, headers: true).each do |line|
        passenger = find_passenger(line[0].to_i)
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:vin] = line[1]
        input_data[:status] = line[2].to_sym
        input_data[:name] = passenger.name
        input_data[:phone] = passenger.phone_number
        driver = Driver.new(input_data)
        passenger_index = @passengers.find_index(passenger)
        @passengers[passenger_index] = driver
        drivers << driver
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
        passenger_as_driver = find_driver(raw_trip[:passenger_id].to_i)


        start_time = Time.parse(raw_trip[:start_time])
        end_time = Time.parse(raw_trip[:end_time])

        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          start_time: start_time,
          end_time: end_time,
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i,
          driver: driver
        }

        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip)
        driver.add_driven_trip(trip)
        if passenger_as_driver != nil
          passenger_as_driver.add_trip(trip)
        end
        trips << trip
      end
      return trips
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

    # private

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end



    # Note: The user_id must correspond to a User instance
   def request_trip(user_id)
     # Finding the User instance
     current_passenger = @passengers.find { |passenger| passenger.id == user_id }

     if current_passenger == nil
       raise ArgumentError.new("There is no user instance with the id #{user_id}")
     end


     # Checking for available drivers that do not have the same id as the user requesting a ride
     available_drivers = []
     @drivers.each do |x|
       if x.status == :AVAILABLE && x.id != user_id.to_i
         available_drivers << x
       end
     end

     # If there are available drivers, then create trip instance.
     if available_drivers.length > 0
       # number_of_drivers = available_drivers.length
       # random_driver = available_drivers[rand(0...number_of_drivers)]
       # random_driver_id = random_driver.id
       first_available_driver = available_drivers.first

       trip_info = {
         id: @trips.length + 1,
         passenger: current_passenger,
         start_time: Time.now,
         end_time: nil,
         cost: nil,
         rating: nil,
         driver: first_available_driver
       }

       trip = Trip.new(trip_info)
       @trips << trip

       # Changing driver data
       first_available_driver.add_driven_trip(trip)
       first_available_driver.change_availability

       # Changing current passenger data
       current_passenger.add_trip(trip)

       return trip

     else
       return "No available drivers"
       # return nil
     end
   end
  end
end
