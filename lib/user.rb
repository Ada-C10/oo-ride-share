require_relative "trip"
require "time"
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
      valid_trips = @trips.reject { |trip| trip.cost.nil? }
      return valid_trips.sum { |trip| trip.cost} if valid_trips.length > 0
    end

    def total_time_spent()
      sum = 0
      @trips.each do |trip|
        if trip.calculate_trip_duration
          sum += trip.calculate_trip_duration
        end
      end

      return sum

    end

  end
end

user = RideShare::User.new(id: 9, name: "Merl Glover III",
                            phone: "1-602-620-2330 x3723", trips: [])

trip = RideShare::Trip.new(id: 8, driver: nil, passenger: user,
                           start_time: Time.parse('2018-06-07 04:19:25 -0700'),
                           end_time: nil,
                           cost: 100,
                           rating: 5)

trip2 = RideShare::Trip.new(id: 10, driver: nil, passenger: user,
                          start_time: Time.parse('2018-06-07 06:19:25 -0700'),
                          end_time: Time.parse('2018-06-07 08:19:25 -0700'),
                          cost: 200,
                          rating: 5)


#

user.add_trip(trip)
user.add_trip(trip2)
ap user.total_time_spent
#
# puts user.net_expenditures()
