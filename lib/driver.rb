module RideShare

  class Driver < User

    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      super(input)



      @vehicle_id = input[:vin]
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]
      @status = input[:status].nil? ? :AVAILABLE : input[:status]

      unless @vehicle_id.length == 17
        raise ArgumentError, "Invalid vehicle ID #{@vehicle_id}"
      end

      unless [:AVAILABLE, :UNAVAILABLE].include?(@status)
        raise ArgumentError, "Invalid status #{@status}"
      end


    end


  end

end
