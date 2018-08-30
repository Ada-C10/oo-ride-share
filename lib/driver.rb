require_relative 'trip'
require_relative 'user'
require 'Time'

module RideShare

  class Driver < User
    attr_reader :vin, :driven_trips, :status

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
