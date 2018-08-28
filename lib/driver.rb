module RideShare
  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(id, name, vehicle_id, phone_number, status, driven_trips = [] )
      super(id, name, phone_number, trips)

      if vehicle_id.length != 17
        raise ArgumentError.new("Invalid VIN")
      else
        @vehicle_id = vehicle_id
      end

      @driven_trips = driven_trips

      if @status != :AVAILABLE && @status != :UNAVAILABLE
        raise ArgumentError.new("Invalid status entered.")
      else
        @status = status
      end
    end

  end
end
