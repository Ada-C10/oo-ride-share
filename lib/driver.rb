require_relative 'trip'
require 'pry'

module RideShare

  class Driver < User

    attr_reader :vin, :status, :driven_trips

    def initialize(input)

      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      if input[:vin] == nil || input[:vin].length != 17 || input[:vin] == " "
        # binding.pry
        raise ArgumentError, 'Vin inaccurate, must be 17 characters long.'
      end


      super(input)
      # @id = input[:id].to_i
      # @name = input[:name].to_s
      @vin	= input[:vin].to_s
      @status = input[:status]
      @driven_trips	= []

      # status_array = [:AVAILABLE, :UNAVAILABLE ]




      # binding.pry
      # unless @status.include?(status_array)
      #   raise ArgumentError. "Invalid status, you entered: #{status}"
      # end


    end

    def add_driven_trip(trip)
      unless trip.is_a? Trip
        raise ArgumentError, "Got a thing that wasn't a trip! (#{trip.class})"
      end
      @driven_trips << trip

    end




    def average_rating #sums rating from all drivers trips and returns the average
      trip_sum = 0.0
      @driven_trips.each do |trip|
        trip_sum += trip.rating
      end
      return trip_sum / @driven_trips.length
    end


    def total_revenue #calculates the drivers total revenue across all of the trips
    end

    def net_expenditures
    end



  end



end
