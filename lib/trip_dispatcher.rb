require 'csv'
require 'time'
require_relative 'user'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    USER_FILE = 'support/users.csv'
    TRIP_FILE = 'support/trips.csv'
    DRIVER_FILE = 'support/drivers.csv'

    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = USER_FILE, trip_file = TRIP_FILE, driver_file = DRIVER_FILE)
      @passengers = load_users(user_file)
      @drivers = load_drivers(driver_file)
      @trips = load_trips(trip_file)
      load_driven_trips_to_drivers
    end

    def load_users(filename)
      users = []
      CSV.read(filename, headers: true, header_converters: :symbol).each do |line|
        input_data = {}
        input_data[:id] = line[:id].to_i
        input_data[:name] = line[:name]
        input_data[:phone] = line[:phone_num]
        users << User.new(input_data)
      end
      return users
    end

    def load_trips(filename)
      trips = []
      CSV.open(filename, 'r', headers: true, header_converters: :symbol).each do |raw_trip|
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

    # pull in drivers.csv and create Driver objects
    def load_drivers_from_csv(filename)
      drivers = []
      CSV.read(filename, headers: true).each do |line|
        driver_input_data = {}
        driver_input_data[:id] = line[0].to_i
        driver_input_data[:vin] = line[1]
        driver_input_data[:status] = line[2].to_sym
        drivers << Driver.new(driver_input_data)
      end
      return drivers
    end

    # add driver's user info to their driver profile
    # replace user objects with their respective driver objects in @passengers
    def merge_drivers_and_users(drivers)
      # find the drivers' user data and add their user info to their Driver object
      drivers.each do |driver|
        # Finding drivers user data based on id
        user = self.find_passenger(driver.id)
        # Adding user info to driver profile
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

    def load_drivers(filename)
      # pull in drivers.csv and create Driver objects
      drivers = load_drivers_from_csv(filename)
      return merge_drivers_and_users(drivers) # drivers with user info
    end

    def load_driven_trips_to_drivers
      trips.each do |trip|
        trip_driver = find_driver(trip.driver.id)
        trip_driver.add_driven_trip(trip)
      end
    end

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end

    # creates and returns a new in progress trip
    def create_new_trip(user_id, selected_driver)
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
    end

    # creates a new in progress trip, assigns an available driver
    def request_trip(user_id)
      # create a collection of only available drivers
      available_drivers = @drivers.select { |driver| driver.status == :AVAILABLE }
      # Ensure a driver who is a passenger is not assigned to themselves
      if available_drivers.empty? ||
        ( available_drivers.length == 1 && available_drivers[0].id == user_id )
        raise RideShare::NoAvailableDriversError, "No drivers available at the moment"
        # If the first available driver is not the user, assign the driver
      elsif available_drivers.first.id != user_id
        # Assign the first available driver
        selected_driver = available_drivers.first
      else
        # Pick the next available driver
        selected_driver = available_drivers[1]
      end

      # Adding new trip to trips
      new_trip = create_new_trip(user_id, selected_driver)
      trips << new_trip

      # Using helper method to set driver status to unavailable
      # And to add the trip to the drivers driven_trips collection
      selected_driver.drive_in_progress(new_trip)

      # Adding trip to passenger's trip collection
      new_trip.passenger.add_trip(new_trip)

      return new_trip
    end
  end

  class NoAvailableDriversError < StandardError
  end
end
