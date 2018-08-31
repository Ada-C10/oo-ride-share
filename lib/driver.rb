require_relative 'trip'
require_relative 'user'
require 'Time'

module RideShare

  class Driver < User
    attr_reader :vin, :driven_trips, :status
    attr_writer :status

    def initialize(input)
      super (input)

      
      if input[:vin].length == 17
        @vin = input[:vin]
      else
        raise ArgumentError.new('Invalid VIN ')
      end

      @driven_trips = []

      if [:AVAILABLE, :UNAVAILABLE].include? (input[:status])
        @status = input[:status]
      else
        raise ArgumentError.new('Invalid STATUS')
      end
    end

    def average_rating
      sum = 0
      @driven_trips.each do |trip|
        sum += trip.rating
      end
      if @driven_trips.length == 0
        return 0
      else
        return sum.to_f/@driven_trips.length
      end
    end

    def total_revenue
      total_revenue = 0
      @driven_trips.each do |driven_trip|
        total_revenue += (driven_trip.cost - 1.65) * 0.8
      end
      return total_revenue
    end

    def net_expenditures
      return super - self.total_revenue
    end

    def driver_on_trip
      @status = :UNAVAILABLE
    end

    def add_driven_trip(trip)
      if trip.class == Trip
        @driven_trips << trip
      else
        raise ArgumentError, "not a trip"
        @driven_trips << trip
      end
    end
  end
end
