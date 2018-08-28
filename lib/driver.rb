# vehicle_id|The driver's Vehicle Identification Number (VIN Number), Each vehicle identification number should be a specific length of 17 to ensure it is a valid vehicle identification number
# driven_trips | A list of trips the user has acted as a driver for.
# status|Indicating availability, a driver's availability should be either `:AVAILABLE` or `:UNAVAILABLE`

module RideShare
  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      super(input)
      if [:AVAILABLE, :UNAVAILABLE].include? input[:status]
        @status = status
      else
        raise ArgumentError, "Invalid status, must be :AVAILABLE or :UNAVAILABLE"
      end
      @vehicle_id = input[:vin]
      @driven_trips = []
    end

  end
end
