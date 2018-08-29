require_relative 'trip'
require 'Time'

module RideShare
  class Driver < User
    attr_reader :vin, :driven_trips, :status

    def initialize(input)
      super (input) #id, name, phone_number, trips

      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      if input[:vin].length == 17
        @vin = input[:vin]
      else
        raise ArgumentError.new('That is not a valid VIN number')
      end

      if [:AVAILABLE, :UNAVAILABLE].include? (input[:status])
        @status = input[:status]
      else
        raise ArgumentError.new('That is not a valid status')
      end

    end

    def add_driven_trip(driver_trip)
      @driven_trips << driver_trip
    end

    def average_rating
      return driven_trips.reduce{|sum, trip| sum.rating + trip.rating } / driven_trips.length
    end

    def total_revenue
      revenue = driven_trips.reduce(0){|sum, trip| sum + (trip.cost - 1.65) }
      revenue*= 0.8
      return revenue
    end

    def net_expenditures
      return trips.reduce{|sum, trip| sum.cost + trip.cost } - self.total_revenue
    end

  end
end
