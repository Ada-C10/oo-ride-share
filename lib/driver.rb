# vehicle_id|The driver's Vehicle Identification Number (VIN Number), Each vehicle identification number should be a specific length of 17 to ensure it is a valid vehicle identification number
# driven_trips | A list of trips the user has acted as a driver for.
# status|Indicating availability, a driver's availability should be either `:AVAILABLE` or `:UNAVAILABLE`

module RideShare
  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      super(input)
      if [:AVAILABLE, :UNAVAILABLE].include? input[:status]
        @status = input[:status]
        # If status is nil, default to UNAVAILABLE
      elsif input[:status] == nil
        @status = :UNAVAILABLE
      else
        # If status is not nil/UNAVAILABLE/AVAILABLE - Raise error
        raise ArgumentError, "Invalid status, must be :AVAILABLE or :UNAVAILABLE"
      end
      @vehicle_id = input[:vin]
      @driven_trips = []
    end

    # Method to add a trip to driven_trips
    def add_driven_trip(trip)
      # Checking if trip is an instance of trip
      if trip.class != Trip
        raise ArgumentError, 'This is not a trip class'
      end
      # Adding trip to driven_trips
      @driven_trips << trip
    end

    # sums up the ratings from all a Driver's trips and returns the average
    def average_rating
      if driven_trips.empty?
        return 0
      else
        return (driven_trips.sum {|driven_trip| driven_trip.rating}).to_f / driven_trips.length
      end
    end

  end
end
