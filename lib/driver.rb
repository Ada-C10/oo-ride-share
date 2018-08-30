require 'csv'
require 'pry'

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
      if trip.end_time == nil
        @status = :UNAVAILABLE
      end
      @driven_trips << trip
    
    end


    def average_rating
      rating_sum = 0.0
      @driven_trips.each do |trip|
        rating_sum += trip.rating
      end
      if @driven_trips.length == 0
         average_rating = 0
      else
         average_rating = (rating_sum / @driven_trips.length).to_f
      end

      return average_rating

    end

    def total_revenue
      total_revenue = 0.0
      @driven_trips.each do |trip|
        x = (trip.cost - 1.65)
        y = x * 0.08
        total_revenue += (x - y)
      end

      if @driven_trips.length == 0
        return total_revenue = 0.0
      else
        return total_revenue.round(2)
      end

    end

    def net_expenditures
      net_expenditures = super - self.total_revenue
      return net_expenditures.round(2)
    end

  end
end
