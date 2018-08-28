require 'pry'
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
      cost_array = []
      @trips.each do |trip|
        cost = trip.cost
        cost_array << cost
      end
      return cost_array.sum
    end

    def total_time_spent
      time_array = []
      @trips.each do |trip|
        time_per_trip = trip.end_time.to_i - trip.start_time.to_i
        time_array << time_per_trip
      end
      return time_array.sum
    end
  end
end
