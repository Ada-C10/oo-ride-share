require_relative 'trip'
require 'Time'

module RideShare
  class Driver < User
    attr_reader :vin, :trips, :status

    def initialize(input)
      super (input) #id, name, phone_number, trips

      @driven_trips = []

      if vin.length == 17
        @vin = vin
      else
        raise ArgumentError.new('That is not a valid VIN number')
      end

      [:AVAILABLE, :UNAVAILABLE].include? (status)
        @status = status
      else
        raise ArgumentError.new('That is not a valid status')
      end

    end

    def driven_trips
    end

  end
end
