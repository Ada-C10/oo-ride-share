require_relative 'user'
require 'pry'

module RideShare
  class Driver < User
    attr_reader :vin, :driven_trips, :status

    def initialize(input)
      super(input)

      @vin = input[:vin]
      if @vin.length != 17
        raise ArgumentError.new("Invalid VIN")
      else
        @vin = input[:vin]
      end

      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      if input[:status] != :AVAILABLE && input[:status] != :UNAVAILABLE
        @status = :UNAVAILABLE
      else
        @status = input[:status]
      end
    end

    def add_driven_trip(trip)
      if trip.is_a? Trip
      # binding.pry
      @driven_trips << trip
      # binding.pry
      else
        raise ArgumentError.new("Invalid trip instance")
      end
    end

    def average_rating
      total_num_rides = @driven_trips.length
      total_sum = 0

      if total_num_rides == 0
        return 0
      end

      @driven_trips.each do |x|
        total_sum += x.rating
      end

      avg_rating = total_sum.to_f / total_num_rides
      return avg_rating

    end
    

    def total_revenue
     total_cost_all_trips = 0
     total_num_rides = @driven_trips.length

     if total_num_rides == 0
       return 0
     end

     @driven_trips.each do |x|
       total_cost_all_trips += x.cost
     end

     all_fees = total_num_rides * 1.65
     driver_revenue = (total_cost_all_trips - all_fees) * 0.8
     driver_revenue_rounded = driver_revenue.round(2)

     return driver_revenue_rounded
   end

  end
end
