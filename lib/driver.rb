require_relative 'user'

STATUS_OPTIONS = [:AVAILABLE, :UNAVAILABLE]
DRIVERS_CUT = 0.8
FEE = 1.65

module RideShare
  class Driver < RideShare::User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      super(input)
      @vehicle_id = input[:vin]
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]
      @status = input[:status].nil? ? :AVAILABLE : input[:status]

      raise ArgumentError.new("That is an invalid status") unless STATUS_OPTIONS.include?(@status)
      raise ArgumentError.new("That is an invalid VIN") unless @vehicle_id.length == 17
    end

    def add_driven_trip(trip)
      raise ArgumentError unless trip.is_a? Trip
      @driven_trips << trip
    end

    def average_rating
      trip_ratings = []
      @driven_trips.each do |trip|
        trip_ratings << trip.rating
      end
      trip_ratings.length == 0 ? 0 : (trip_ratings.sum / trip_ratings.length).to_f
    end

    def total_revenue
      total_revenue = 0
      @driven_trips.each do |trip|
        total_revenue += (DRIVERS_CUT * (trip.cost - FEE))
      end
      return total_revenue.round(2)
    end

    def net_expenditures
      return (super - total_revenue).round(2)
    end

    def becomes_unavailable
      @status = :UNAVAILABLE
    end
  end
end
