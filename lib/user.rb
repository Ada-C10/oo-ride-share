require_relative 'trip'
require 'Time'
module RideShare
  class User
    attr_reader :id, :name, :phone, :trips

    def initialize(input)
      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      @id = input[:id]
      @name = input[:name]
      @phone = input[:phone]
      @trips = input[:trips].nil? ? [] : input[:trips]
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      trips.reduce(0){|sum, trip| sum + trip.cost }
    end

    def total_time_spent
      trips.reduce{|sum, trip| sum.trip_duration + trip.trip_duration }
    end
  end
end
