#
# require 'pry'
module RideShare
  class User
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips].nil? ? [] : input[:trips]
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      costs = @trips.map {|trip_stuff| trip_stuff.cost}
        cost_total = costs.inject(:+).to_f
        return cost_total
    end

    def total_time_spent
      time_spent = @trips.map {|trip| trip.trip_duration}
      total_time = time_spent.reduce(:+)
      return total_time
    end
    # This is the end of the ends for the class and the modules
  end
end
