
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
      costs = []
      @trips.each do |trip_stuff|
        costs << trip_stuff.cost
      end
      cost_total = costs.inject(:+).to_f
      return cost_total
    end
    # This is the end of the ends for the class and the modules
  end
end
