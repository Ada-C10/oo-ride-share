# vehicle_id|The driver's Vehicle Identification Number (VIN Number), Each vehicle identification number should be a specific length of 17 to ensure it is a valid vehicle identification number
# driven_trips | A list of trips the user has acted as a driver for.
# status|Indicating availability, a driver's availability should be either `:AVAILABLE` or `:UNAVAILABLE`
require 'pry'

module RideShare
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
        raise ArgumentError, "Invalid status, must be :AVAILABLE or :UNAVAILABLE"
      end
      raise ArgumentError, "Invalid VIN, must be 17 characters long" if input[:vin].length != 17
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

    # returns an array of only completed driven trips
    def filter_completed_trips(driven_or_riden_trips)
      return driven_or_riden_trips.select { |trip| trip.end_time != nil }
    end

    # sums up the ratings from all a Driver's trips and returns the average
    def average_rating
      if driven_trips.empty?
        return 0.0
      end

      completed = filter_completed_trips(driven_trips)

      return (completed.sum { |completed_trip|
          completed_trip.rating
        }).to_f / completed.length
    end

    def total_revenue
      if driven_trips.empty?
        return 0.00
      end

      completed = filter_completed_trips(driven_trips)

      return ((completed.sum {|completed_trip| completed_trip.cost - 1.65}) * 0.8).round(2)
    end

    def net_expenditures
      completed_riden = filter_completed_trips(trips)

      return (completed_riden.reduce(0) { |sum, completed_trip| sum + completed_trip.cost }) - total_revenue
    end

    # Helper method to add a trip/set status to unavailable when trip is in progress for driver
    def drive_in_progress(trip)
      self.add_driven_trip(trip)
      self.status = :UNAVAILABLE
    end

  end
end
