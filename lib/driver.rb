require 'pry'

module RideShare
  class Driver < User
    attr_reader :vehicle_id, :driven_trips
    attr_accessor :status

    # initialize
    def initialize(input)
      super(input)
      @vehicle_id = input[:vin]
      @status = input[:status] ||= :AVAILABLE
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      raise ArgumentError, "No VIN number provided" if @vehicle_id == nil || @vehicle_id.length != 17
      raise ArgumentError, "Invalid status, must be either :AVAILABLE or :UNAVAILABLE" if @status != :AVAILABLE && @status != :UNAVAILABLE
    end

    # a method for add trip to the driven_trips array
    def add_driven_trip(trip)
      if trip.class != Trip
        raise ArgumentError, "A Trip was not provided"
      end
      @driven_trips.each do |item|
         if item == trip
           raise ArgumentError, "Duplicated trip"
         end
       end
      @driven_trips << trip
    end

    # calculate the average rating of the driver
    def average_rating
      if driven_trips.length == 0
        return 0
      else
        completed_trips = driven_trips.reject {|trip| trip.rating.nil?}.map{|item| item.rating}
        return completed_trips.sum.to_f / completed_trips.length
      end
    end

    # calculate the total_revenue of each driver
    def total_revenue
      costs = @driven_trips.reject {|trip| trip.cost.nil?}.map {|item| item.cost}
      calculated_costs = costs.sum {|item| (item - 1.65) * 0.8.round(2)}
      return calculated_costs
    end

    # calcuate the net_expenditure for each driver.
    def net_expenditures
      return super - total_revenue
    end
  end

end
