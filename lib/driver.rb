require 'csv'

module RideShare
  class Driver < User
    attr_reader :vin, :status, :driven_trips
    VALID_STATUSES = [:AVAILABLE, :UNAVAILABLE]
    def initialize(input)

      unless VALID_STATUSES.include?(input[:status])
        raise ArgumentError
      end

      super (input)
      @vin = input[:vin]
      @status = input[:status]
      @driven_trips = input[:trips].nil? ? [] : input[:trips]
    end

    def add_driven_trip(trip)
      unless trip.is_a?(Trip)
        raise ArgumentError
      end

      @driven_trips << trip
    end

  end
end
