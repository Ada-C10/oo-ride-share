require_relative 'trip'
require_relative 'user'
require 'Time'
require 'pry'

module RideShare
  class Driver < User
    attr_reader :vin, :driven_trips
    attr_accessor :status

    def initialize(input)
      super (input) #id, name, phone_number, trips
      @status = input[:status]
      @vin = input[:vin]
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      if input[:vin].length != 17
        raise ArgumentError.new('That is not a valid VIN number')
      end

      if [:AVAILABLE, :UNAVAILABLE].include? (input[:status])
        @status = input[:status]
      else
        raise ArgumentError.new('That is not a valid status')
      end
    end

    def add_driven_trip(driver_trip)
      if driver_trip.class != RideShare::Trip
        raise ArgumentError.new("To add a driven trip needs to be a class of a trip.")
      else
        @driven_trips << driver_trip
      end
    end
    def average_rating
      if driven_trips.length == 0
        return 0
      else
        sum_ratings =  driven_trips.reduce(0){|sum, trip| sum + trip.rating.to_f }
        return sum_ratings / driven_trips.length
      end
    end

    def total_revenue
      revenue = driven_trips.reduce(0){|sum, trip| sum + (trip.cost - 1.65) }
      revenue*= 0.8
      return revenue.round(2)
    end

    def net_expenditures
      money_spent = super
      return money_spent - self.total_revenue
    end

  end
end
