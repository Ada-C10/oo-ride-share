require_relative 'user'
require_relative 'trip'

module RideShare
  class Driver < RideShare::User
    attr_reader :vin, :vehicle_id, :driven_trips, :status

    @@driver_list = []

    def initialize(input)
      super(input)

      if input[:vin].nil? || input[:vin].length != 17
        raise ArgumentError, 'VIN cannot be blank or have letters.'
      end

      @vehicle_id = ""

      @vin = input[:vin]
      @vehicle_id ||= input[:vehicle_id]
      @driven_trips ||= []
      @status = input[:status]
      @@driver_list << self

  end

def add_driven_trip(trip)

#return @drivers.find { |driver| driver.id == TripDispatcher.id }
@driven_trips << trip
end


end
end
