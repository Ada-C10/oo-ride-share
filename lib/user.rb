require_relative "trip"
require "Time"
require "ap"
require "pry"

module RideShare
  class User
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips].nil? ? [] : input[:trips]
    end

    # trips (array) will hold each instance of trip (as an object) from Trip class
    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures()
       return @trips.sum { |trip| trip.cost}
    end

    def total_time_spent()
      return @trips.sum { |trip| trip.calculate_trip_duration}
    end

  end
end

# user = RideShare::User.new(id: 9, name: "Merl Glover III",
#                             phone: "1-602-620-2330 x3723", trips: [])
#
# trip = RideShare::Trip.new(id: 8, driver: nil, passenger: user,
#                            start_time: Time.parse("2016-08-08"),
#                            end_time: Time.parse("2016-08-09"),
#                            cost: 500,
#                            rating: 5)
#
# trip2 = RideShare::Trip.new(id: 10, driver: nil, passenger: user,
#                           start_time: Time.parse("2016-08-08"),
#                           end_time: Time.parse("2016-08-09"),
#                           cost: 200,
#                           rating: 5)
#
#
#
#
# user.add_trip(trip)
# user.add_trip(trip2)
#
# puts user.net_expenditures()
