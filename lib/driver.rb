require 'pry'
require_relative 'trip.rb'
require_relative 'user.rb'

module RideShare
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
      if trip.class == RideShare::Trip
        @driven_trips << trip
      else
        raise ArgumentError, 'trip is not provided'
      end
    end

    def average_rating
      if @driven_trips == []
        return 0
      else
        total_ratings = @driven_trips.reduce(0) do |result, trip|
          result + trip.rating
        end
        return (total_ratings.to_f / @driven_trips.length).round(2)
      end
    end

    def total_revenue
      total_revenue = @driven_trips.reduce(0) do |result, trip|
        result + 0.8 * (trip.cost-1.65)
      end
      return total_revenue.round(2)
    end

    def net_expenditures
      made_as_driver = total_revenue
      spent_as_passenger = super

      net_earnings = spent_as_passenger - made_as_driver

      return net_earnings.round(2)
    end

    def in_progress_trip(trip)
      @driven_trips << trip
      trip.status = :UNAVAILABLE
    end
  end
end
