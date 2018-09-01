require_relative 'user'


module RideShare
  class Driver < User

  attr_reader :vehicle_id, :driven_trips
  attr_accessor :status

    def initialize(input)
      super(input)

      if input[:vehicle_id].length != 17 || input[:vehicle_id].empty?
        raise ArgumentError, "Invalid VIN #{input[:vehicle_id]}in driver CSV (expected length 17)"
      end

      @vehicle_id = input[:vehicle_id]
      @status = input[:status]
      @driven_trips = []#input[:trips].nil? ? [] : input[:trips]

    end

    #assinged as to_i in dispatch spec but binding is a float in driver.rb
    def add_driven_trip(trip)
      raise ArgumentError unless trip.class == Trip
      @driven_trips << trip #using the method in load trips to call
    end

    def average_rating
      if @driven_trips == []
        return 0
      else
        sum = 0
        @driven_trips.each do |trip|
          sum += trip.rating
        end
        return sum.to_f / @driven_trips.length
      end
    end

    def total_revenue
      sum = 0
      @driven_trips.each do |trip|
        if trip.cost == nil
          sum += 0
        else
          sum += (trip.cost - 1.65)
        end
      end
      return revenue = (sum * 0.80)
    end

    def net_expenditures # driver.net_expenditures
      return super - total_revenue
    end

  end
end
