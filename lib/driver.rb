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

      @driven_trips << trip
    end


    def average_rating
      rating_sum = 0
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

  end
end
