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
      total_spent = @trips.reduce(0) do |result, trip|
        result + trip.cost
      end
      return total_spent.round(2)
    end

    def total_time_spent
      total_time = @trips.reduce(0) do |result, trip|
        result + (trip.end_time - trip.start_time)
      end
      return total_time.round
    end
  end

  class Driver < User
    attr_reader :id, :name, :vehicle_id, :phone, :status, :driven_trips, :trips
    def initialize(id: 0, name: "", vin: "", phone:"", trips: [], status: :AVAILABLE, driven_trips: [])
      if id <= 0
        raise ArgumentError.new("Bad ID Value")
      end
      @id = id
      @name = name
      if vin.empty? || vin.length != 17
        raise ArgumentError.new("Invalid VIN number")
      end
      @vehicle_id = vin
      @phone = phone
      @status = status
      @driven_trips = driven_trips
      @trips = trips
    end

    def add_driven_trip(trip)
      @driven_trips << trip
    end
  end
end
