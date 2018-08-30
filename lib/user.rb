require 'pry'
require_relative 'trip.rb'

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
      if @trips == 0
        return 0
      else
        total_spent = @trips.reduce(0) do |result, trip|
          result + trip.cost
        end
        return total_spent.round(2)
      end
    end

    def total_time_spent
      total_time = @trips.reduce(0) do |result, trip|
        result + (trip.end_time - trip.start_time)
      end
      return total_time.round
    end
  end
end
