require 'csv'
require 'time'
require_relative "user"

module RideShare

  class Driver < User
    attr_reader :vin, :driven_trips
    attr_accessor :status

    def initialize(input)
      super(input)

      @vin = input[:vin].to_s

      if @vin.nil? || @vin == 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end


      if input[:vin].length != 17 || input[:vin].length == 0
        raise ArgumentError, 'vin numbers must be 17 characters in length'
      end

      @status = input[:status]

      unless @status == :AVAILABLE
        @status == :UNAVAILABLE

      end


      @driven_trips = input[:trips].nil? ? [] : input[:trips]
    end

    def add_driven_trip(driven_trip)
      @driven_trips << driven_trip

      unless driven_trip.is_a? Trip
        raise ArgumentError
      end

    end


    def average_rating
      total_rating = 0

      @driven_trips.each do |trip|
        total_rating += trip.rating
      end

      if @driven_trips.length == 0
        average = 0
      else
        average = total_rating.to_f/@driven_trips.length
      end
      return average
    end


    def total_revenue
      total_revenue = 0

      @driven_trips.each do |trip|
        total_revenue += trip.cost
      end

      if @driven_trips.length == 0
        total = 0
      else
        total = (total_revenue.to_f - 1.65)*0.8
      end
      return total
    end


    def net_expenditures
      return super - total_revenue.round(2)

    end


  end
end
