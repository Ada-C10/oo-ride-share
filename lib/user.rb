require_relative 'trip'
require 'Time'
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
      trips.reduce{|sum, trip| sum.cost + trip.cost }
    end


  end
end
@user = RideShare::User.new(id: 9, name: "Merl Glover III",
                            phone: "1-602-620-2330 x3723", trips: [])
trip = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                           start_time: Time.parse("2016-08-08"),
                           end_time: Time.parse("2016-08-09"), cost: 5, rating: 5)
trip_2 = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                           start_time: Time.parse("2016-08-08"),
                           end_time: Time.parse("2016-08-09"),cost: 10, rating: 5)
@user.add_trip(trip)
@user.add_trip(trip_2)
#puts user.net_expenditures
