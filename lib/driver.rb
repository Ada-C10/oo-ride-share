require_relative "trip"
require_relative "user"
require "Time"
require "ap"
require "pry"

module RideShare
  class Driver < User
    attr_reader :id, :name, :phone_number, :trips, :vehicle_id, :driven_trips, :status

    def initialize(input)
      super (id, name, phone_number, trips)

      @vehicle_id = input[:vehicle_id]
      @driven_trips = []
      @status = input[:status]

      unless input[:vehicle_id] == 17
        raise ArgumentError, 'Vehicle ID must contain 17 characters'
      end

      unless input[:status] == :AVAILBLE || input[:status] == :UNAVAILABLE
        raise ArgumentError, 'Vehicle ID must contain 17 characters'
      end

      # if input[:id].nil? || input[:id] <= 0
      #   raise ArgumentError, 'ID cannot be blank or less than zero.'
      # end
      #
      # @id = input[:id]
      # @name = input[:name]
      # @phone_number = input[:phone]
      # @trips = input[:trips].nil? ? [] : input[:trips]
    end
  end
end
