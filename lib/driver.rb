module RideShare
  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      super(input)
      @vehicle_id = input[:vin]
      @status = input[:status]
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      raise ArgumentError, "No VIN number provided" if @vehicle_id == nil || @vehicle_id.length != 17
      raise ArgumentError, "No id number provided" if @id <= 0
      raise ArgumentError, "Invalid status, must be either :AVAILABLE or :UNAVAILABLE" if @status != :AVAILABLE && @status != :UNAVAILABLE
    end

  end

end
