require 'csv'
require 'time'
require_relative "user"

module RideShare

  class Driver < User
    attr_reader :vin, :status, :driven_trips  #:trips is the trips taken as a user

    def initialize(input) #rather than input, pass in symbol vin, status, and driven trips
      super(input)
      # inherits @id, @name, @phone as param and inst var (?)
      # inherits @trips from User (?) as instance variable not parameter
      # rather than input[:vin], just :vin

      @vin = input[:vin].to_s

      if @vin.nil? || @vin == 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end


      if input[:vin].length != 17 || input[:vin].length == 0
        raise ArgumentError, 'vin numbers must be 17 characters in length'
      end

      @status = input[:status]
      # valid_status = %i[AVAILABLE UNAVAILABLE]
      unless @status == :AVAILABLE
        @status == :UNAVAILABLE
        # raise ArgumentError, 'Not a valid status.'
      end


      @driven_trips = input[:trips].nil? ? [] : input[:trips]
    end

    def add_driven_trip(driven_trip)
      @driven_trips << driven_trip

      unless driven_trip.is_a? Trip
        raise ArgumentError
      end

    end

    # def add_driven_trip
    #   @trip.each do |trip|
    #     if user.id == trip[1]
    #       @driven_trips << trip
    #     end
    #
    #     if @driven_trips.length == 0
    #       raise ArgumentError, "No trip provided."
    #     end
    #
    #     return @driven_trips
    #   end


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
      return super - total_revenue

    end


  end
end
