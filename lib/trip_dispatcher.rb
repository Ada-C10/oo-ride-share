require 'csv'

require_relative 'user'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(
      user_file = 'support/users.csv',
      driver_file = 'support/drivers.csv',
      trip_file = 'support/trips.csv'
    )
    @passengers = load_users(user_file)
    @drivers = load_drivers(driver_file)
    @trips = load_trips(trip_file)
  end

  def load_drivers(filename)
    drivers = []

    CSV.read(filename, headers: true).each do |line|
      passenger = @passengers.find { |passenger| passenger.id == line[0].to_i }

      input_data = {}
      input_data[:id] = line[0].to_i
      input_data[:vin] = line[1]
      input_data[:status] = line[2].to_sym
      input_data[:name] = passenger.name

      driver = Driver.new(input_data)
      drivers << driver
    end
    return drivers
  end

  def find_driver(id)
    check_id(id)
    return @drivers.find { |driver| driver.id == id }
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
          driver: driver,
          passenger: passenger,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }

        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip)
        driver.add_driven_trip(trip)
        trips << trip
      end

      return trips
    end

    def find_passenger(id)
      check_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def first_available_driver
      first_available_driver  = generate_available_drivers.first
    end

    def generate_available_drivers
      available_drivers = @drivers.find_all do |driver|
        driver.status == :AVAILABLE
      end

      raise ArgumentError.new("NO DRIVERS AVAILABLE") if available_drivers.empty?
      return available_drivers
    end

    def request_trip(user_id)
      id = @trips.length + 1
      passenger = find_passenger(user_id)
      driver = first_available_driver

      trip_data = {
        id: id,
        driver: driver,
        passenger: passenger,
        start_time: Time.now
      }

      requested_trip = Trip.new(trip_data)
      driver.is_unavailable
      driver.add_driven_trip(requested_trip)

      passenger.add_trip(requested_trip)
      @trips << requested_trip
      return requested_trip
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
