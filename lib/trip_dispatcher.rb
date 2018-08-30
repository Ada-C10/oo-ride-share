require 'csv'
require 'time'
require 'pry'
require_relative 'user'
require_relative 'trip'
require_relative 'driver'
require 'awesome_print'

# TODO DELETE THIS LATER - IS FOR TESTING CODE
# USER_TEST_FILE   = 'support/users.csv'
# TRIP_TEST_FILE   = 'support/trips.csv'
# DRIVER_TEST_FILE = 'support/drivers.csv'

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'


module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv',
                   trip_file = 'support/trips.csv',
                  driver_file = 'support/drivers.csv')
      @passengers = load_users(user_file)
      @drivers = load_drivers(driver_file)
      @trips = load_trips(trip_file)
      self.load_driven_trips_to_drivers
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

        # binding.pry
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

    def inspect
      return "#<#{self.class.name}:0x#{self.object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def find_driver(id)
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    # Method to load drivers
    def load_drivers(filename)
      drivers = []

      # pull in drivers.csv and create Driver objects
      CSV.read(filename, headers: true).each do |line|
        driver_input_data = {}
        driver_input_data[:id] = line["id"].to_i
        driver_input_data[:vin] = line["vin"]
        driver_input_data[:status] = line["status"].to_sym
        drivers << Driver.new(driver_input_data)
        # binding.pry
      end

      # find the drivers' passenger data and add their
      # passenger info to their Driver object
      drivers.each do |driver|
        # Finding drivers user data based on id
        user = self.find_passenger(driver.id)
        # Assigning driver information based on user
        if user
          driver.name = user.name
          driver.phone_number = user.phone_number
          driver.trips = user.trips
        end

        # Swapping out passenger with driver
        @passengers[@passengers.index(user)] = driver
      end

      return drivers
    end

    def load_driven_trips_to_drivers
      trips.each do |trip|
        trip_driver = find_driver(trip.driver.id)
        trip_driver.add_driven_trip(trip)
      end
    end

    # Method to find drivers
    def find_driver(id)
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end

    # def request_trip(user_id)
    #   # map drivers based on available status
    #   #randomly first driver from that pool
    #   new_trip_data = {id: ???new trip id??????, passenger: find_passenger(user_id),
    #         start_time: Time.current????, end_time: nil, cost: nil, rating: nil, driver: the driver we found above}
    #   new_trip = Trip.new(new_trip_data)
    #   trips << new_trip (push new trip into array of trips in tripdispatcher)
    #   return new_trip
    # end


    def request_trip(user_id)
      available_drivers = @drivers.select { |driver| driver.status == :AVAILABLE }
      # Driver can't be itself / Can't select the driver if it's the
      # only one left and it's the user as well
      if available_drivers.empty? ||
        ( available_drivers.length == 1 && available_drivers[0].id == user_id )
        raise ArgumentError, "No drivers available at the moment"
        # If the first available driver is not the user, assign the driver
      elsif available_drivers.first.id != user_id
        # Assign the first available driver
        selected_driver = available_drivers.first
      else
        # Pick the next available driver
        selected_driver = available_drivers[1]
      end
      # binding.pry
      # Creating new trip data
      new_trip_data = {
        id: (trips.last.id + 1),
        passenger: find_passenger(user_id),
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: selected_driver
      }

      # Creating a new instance of Trip
      new_trip = Trip.new(new_trip_data)

      # Adding new trip to trips
      trips << new_trip

      # Using helper method to set driver status to unavailable
        # And to add the trip to the drivers driven_trips collection
      selected_driver.drive_in_progress(new_trip)

      # Adding trip to passenger's trip collection 
      new_trip.passenger.add_trip(new_trip)

      return new_trip
      #new_trip_data = {id: ???new trip id??????, passenger: find_passenger(user_id),
      #         start_time: Time.current????, end_time: nil, cost: nil, rating: nil, driver: the driver we found above}
      #   new_trip = Trip.new(new_trip_data)
      #   trips << new_trip (push new trip into array of trips in tripdispatcher)
      #   return new_trip

    end

    private
  end
end

#
dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                               DRIVER_TEST_FILE)

dispatcher.request_trip(1)
#
# binding.pry
