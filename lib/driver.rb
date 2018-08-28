require_relative 'user'
module RideShare
  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input, vehicle_id, driven_trips, status)
      super(input)

      if input[:vehicle_id].length != 17
        raise ArgumentError, 'ID must be 17 characters'
      end
      valid_staus = [:AVAILABLE, :UNAVAILABLE]
      if valid_staus.include?(@status)
        raise ArgumentError, 'Not a valid status'
      end

      @vehicle_id = input[:vehicle_id]
      @driven_trips = input[:driven_trips]
      @status = input[:status]
    end
  end
end
