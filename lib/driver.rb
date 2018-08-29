require_relative 'user'

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

      raise ArgumentError.new unless [:AVAILABLE, :UNAVAILABLE].include?(@status)

      raise ArgumentError.new unless @vehicle_id.length == 17

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
      total_expenditures = 0
      @trips.each do |trip|
        total_expenditures += trip.cost
      end
      return (total_expenditures - self.total_revenue).round(2)
    end

    def add_in_progress_trip(trip)
      @driven_trips << trip
      @status = :UNAVAILABLE
    end
  end
end
