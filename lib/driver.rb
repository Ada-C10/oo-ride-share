# require 'pry'

module RideShare
  class Driver < User
    class InvalidVinError < ArgumentError
    end

    class InvalidStatusError < ArgumentError
    end

    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      super (input)

      @vehicle_id = input[:vin]
      unless @vehicle_id.length == 17 && @vehicle_id =~ /[\dA-Z]/
        raise InvalidVinError, "Wrong number of VIN character"
      end

      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      @status = input[:status].to_sym
      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise InvalidStatusError, "Wrong status #{@status}, type #{@status.class}"
      end
    end

    # def average_rating
    #   @trips
    # end
    def add_driven_trip(trip)
      if trip.class != Trip
        raise ArgumentError, "No trip provided"
      end

      @driven_trips << trip
    end

    def average_rating
      sum = 0.00
      @driven_trips.each do |trip|
        sum += trip.rating.to_f
        # binding.pry
      end
      size = @driven_trips.length
      average = sum/size

      return average
    end

  end
end
