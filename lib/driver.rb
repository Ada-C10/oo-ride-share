require_relative "user"
require 'csv'
require 'time'

module RideShare
  class Driver < User
    attr_reader :vehicle_id, :status, :driven_trips  #:trips is the trips taken as a user

    def initialize(input) #rather than input, pass in symbol vin, status, and driven trips
      super(input)
      # inherits @id, @name, @phone as param and inst var (?)
      # inherits @trips from User (?) as instance variable not parameter
      # rather than input[:vin], just :vin

      @vehicle_id = input[:vin]

      if @vehicle_id.nil? || @vehicle_id == 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      #
      # if input[:vin].length != 17
      #   raise ArgumentError, 'vin numbers must be 17 characters in length'
      # end

      @status = status
      # conditional for two status options

      # @driven_trips = driven_trips[:trips].nil? [] : driven_trips[:trips]
      # @driven_trips =
      # if driven_trips[:trips].nil?
      #   @driven_trips = []
      # else
      #   @driven_trips = driven_trips[:trips]
      # end
      @driven_trips = input[:trips].nil? ? [] : input[:trips]





    end


  end
end
