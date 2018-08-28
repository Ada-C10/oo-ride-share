require_relative 'user'

module RideShare
  class Driver < User
    attr_reader :vehicle_id :driven_trips :status

    def initialize (id, name, phone_number, trips, vehicle_id, driven_trips, status)
      super (id, name, phone_number, trips)
      @vehicle_id = vehicle_id
      @driven_trips = driven_trips
      @status = status
    end

  end
end
