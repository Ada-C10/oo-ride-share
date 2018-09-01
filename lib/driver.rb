require 'csv'
require 'pry'

module RideShare
  class Driver < User
    attr_reader :vin, :driven_trips
    attr_accessor :status

    VALID_STATUSES = [:AVAILABLE, :UNAVAILABLE]

    def initialize(input)
      # raises an argument error if bogus status for drivers is given
      if VALID_STATUSES.include?(input[:status]) == false
        raise ArgumentError
        # if status is nil then set it to unavailable
      elsif input[:status] == nil
        @status = :UNAVAILABLE
      else
        @status = input[:status]
      end

      # check for a valid vin number
      if input[:vin].length != 17
        raise ArgumentError
      end

      super (input)
      @vin = input[:vin]
      @driven_trips = input[:trips].nil? ? [] : input[:trips]

    end

    # helper method to add driven trip to driver
    def add_driven_trip(trip)
      unless trip.is_a?(Trip)
        raise ArgumentError
      end

      if trip.end_time == nil
        @status = :UNAVAILABLE
      end

      @driven_trips << trip

      return @driven_trips
    end

    def most_recent_trip

      return @driven_trips.sort_by{ |trip| trip.end_time }.first
    end


    # average rating for drivers
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

    # total revenue calculator
    def total_revenue
      if @driven_trips == nil
        return 0
      end

      total_revenue = 0.0
      @driven_trips.each do |trip|
        x = (trip.cost - 1.65)
        y = x * 0.08
        total_revenue += (x - y)
      end

      return total_revenue.round(2)
    end


    def net_expenditures
      net_expenditures = super - self.total_revenue
      return net_expenditures.round(2)
    end
  end
end
