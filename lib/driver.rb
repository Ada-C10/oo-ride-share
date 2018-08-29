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

      @driven_trips = input[:trips]

      @status = input[:status].to_sym
      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise InvalidStatusError, "Wrong status"
      end
    end
  end
end
