require_relative 'user'

module RideShare
  class Driver < User
    attr_reader :vin, :driven_trips
    attr_accessor :status

    def initialize(input)
      super(input)
      if input[:vin].length != 17
        raise ArgumentError, 'ID must be 17 characters'
      end

      # valid_staus = [:AVAILABLE, :UNAVAILABLE]
      # if valid_staus.include?(@status)
      #   raise ArgumentError, 'Not a valid status'
      # end

      @vin = input[:vin]
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]
      @status = input[:status] == nil ? :AVAILABLE : input[:status]
    end

    def average_rating
      ratings = @driven_trips.find { |trip| trip.rating }
      average = ratings.sum / @driven_trips.length
      total_ratings = 0
      @trips.each do |trip|
        total_ratings += trip.rating
      end

      if trips.length == 0
        average = 0
      else
        average = (total_ratings.to_f) / trips.length
      end
      return average
    end

    def add_driven_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to driven_trips array")
      end
      @driven_trips << trip
    end

    def total_revenue
      revenue = 0
      @trips.each do |trip|
        if trip.trip_duration != nil
          revenue += trip.cost
        end
        if revenue > 1.65
          income_revenue = (revenue - 1.65) * 0.8
        else
          income_revenue = revenue
        end
      end
      return income_revenue
    end

    # def net_expenditures
    # end

  end
end
