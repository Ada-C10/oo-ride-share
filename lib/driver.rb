module RideShare
  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      # super(id, name, phone_number, trips)
      super(input)

      @id = input[:id]

      if vehicle_id.length != 17
        raise ArgumentError.new("Invalid VIN")
      else
        @vehicle_id = input[:vehicle_id]
      end

      @driven_trips = input[:driven_trips]

      if @status != :AVAILABLE && @status != :UNAVAILABLE
        raise ArgumentError.new("Invalid status entered.")
      else
        @status = input[:status]
      end
    end

  end
end
