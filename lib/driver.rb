require_relative 'trip'
require 'Time'
module RideShare
  class Driver < User
    attr_reader :vehicle_id, :trips, :status

    def initialize(id, name, vehicle_id, status = :UNAVAILABLE)
      super (id, name, phone_number)
      @trips =[]

      if vehicle_id.length == 17
        @vehicle_id = vehicle_id
      else
        raise ArgumentError.new('That is not a valid VIN number')
      end

      [:AVAILABLE, :UNAVAILABLE].include? (status)
        @status = status
      else
        raise ArgumentError.new('That is not a valid status')
      end

    end

  end
end
