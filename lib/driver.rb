require_relative 'user'

module RideShare
  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      super(input)
      if input[:vehicle_id].length != 17
        raise ArgumentError, 'ID must be 17 characters'
      end

      valid_staus = [:AVAILABLE, :UNAVAILABLE]
      if valid_staus.include?(@status)
        raise ArgumentError, 'Not a valid status'
      end

      @vehicle_id = input[:vehicle_id]
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]
      @status = input[:status]
    end

    def average_rating
      ratings = @driven_trips.find { |trip| trip.rating }
      average = ratings.sum / @driven_trips.length
      return average
    end

    # def add_driven_trip
    # end
    #
    # def total_revenue
    # end
    #
    # def net_expenditures
    # end

  end
end
