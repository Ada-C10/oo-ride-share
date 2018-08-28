require 'pry'
require_relative 'trip.rb'

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

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      total_spent = @trips.reduce(0) do |result, trip|
        result + trip.cost
      end
      return total_spent.round(2)
    end

    def total_time_spent
      total_time = @trips.reduce(0) do |result, trip|
        result + (trip.end_time - trip.start_time)
      end
      return total_time.round
    end
  end
end

# user = RideShare::User.new(id: 9, name: "Merl Glover III",
#                             phone: "1-602-620-2330 x3723", trips: [])
# trip_1 = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
#                            start_time: Time.parse("2016-08-08"),
#                            end_time: Time.parse("2016-08-09"), cost: 5.25,
#                            rating: 5)
# trip_2 = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
#                             start_time: Time.parse("2016-08-07"),
#                             end_time: Time.parse("2016-08-10"), cost: 10.84,
#                             rating: 5)
# trip_3 = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
#                             start_time: Time.parse("2016-08-01"),
#                             end_time: Time.parse("2016-08-03"), cost: 35.20,
#                             rating: 5)
#
# user.add_trip(trip_1)
# user.add_trip(trip_2)
# user.add_trip(trip_3)
#
# user.total_time_spent
