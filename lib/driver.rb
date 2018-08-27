require_relative 'user'

module RideShare
  class Driver < RideShare::User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      super(input)
      @vehicle_id = input[:vin]
      @driven_trips = input[:driven_trips]
      @status = input[:status]

      raise ArgumentError.new unless [:AVAILABLE, :UNAVAILABLE].include?(@status)

      raise ArgumentError.new unless @vehicle_id.length == 17

    end

  end
end
