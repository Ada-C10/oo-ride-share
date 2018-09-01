require_relative "trip"
require "time"


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

    def net_expenditures()
      valid_trips = @trips.reject { |trip| trip.cost.nil? }
      return valid_trips.sum { |trip| trip.cost} if valid_trips.length > 0
    end

    def total_time_spent()

      valid_trips = @trips.reject { |trip| trip.calculate_trip_duration.nil? }

      return valid_trips.sum {|trip| trip.calculate_trip_duration} if valid_trips.length > 0

    end

  end
end
