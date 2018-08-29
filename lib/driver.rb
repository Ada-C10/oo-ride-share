require_relative 'user'
require 'pry'

module RideShare
  class Driver < User

    attr_reader :id, :name, :vin, :phone_number, :status, :driven_trips

    def initialize(input)
      super
      @vin = input[:vin]
      @driven_trips = input[:driven_trips]
      @status = input[:status]

      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      elsif input[:vin].length != 17
        raise ArgumentError, 'vin must be 17 characters'
      elsif input[:driven_trips].nil?
        @driven_trips = []
      end
    end

    def add_trip(trip)
      @trips << trip
    end

  end
end
