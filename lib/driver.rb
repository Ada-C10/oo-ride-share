require_relative 'user'

module RideShare
  class Driver < User
    attr_reader :vin :driven_trips :status

    def initialize (id, name, phone_number, trips, vin, driven_trips, status)

      super (id, name, phone_number, trips)
      @vin = vin
      @driven_trips = driven_trips
      @status = status

    end

  end
end
