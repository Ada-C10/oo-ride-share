module RideShare
  class InvalidDriverData < StandardError
  end

  class Driver < User
    attr_reader :vehicle_id, :driven_trips
    attr_accessor :status

    def initialize(input)
      super(input)
      if [:AVAILABLE, :UNAVAILABLE].include? input[:status]
        @status = input[:status]
        # If status is nil, default to UNAVAILABLE
      elsif input[:status] == nil
        @status = :UNAVAILABLE
      else
        # If status is not nil/UNAVAILABLE/AVAILABLE - Raise error
        raise InvalidDriverData, "Invalid status, must be :AVAILABLE or :UNAVAILABLE"
      end
      raise InvalidDriverData, "Invalid VIN, must be 17 characters long" if input[:vin].length != 17
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
      driven_trips << trip
    end

    # sums up the ratings from all a Driver's trips and returns the average
    def average_rating
      return 0.0 if driven_trips.empty?
      completed = filter_completed_trips(driven_trips)
      return (completed.sum { |completed_trip|
          completed_trip.rating
        }).to_f / completed.length
    end

    def total_revenue
      return 0.0 if driven_trips.empty?
      completed = filter_completed_trips(driven_trips)
      return ((completed.sum {|completed_trip| completed_trip.cost - 1.65}) * 0.8).round(2)
    end

    def net_expenditures
      completed_riden = filter_completed_trips(trips)
      return super - total_revenue
    end

    # Helper method to add a trip/set status to unavailable when trip is in progress for driver
    def drive_in_progress(trip)
      self.add_driven_trip(trip)
      self.status = :UNAVAILABLE
    end
  end
end
