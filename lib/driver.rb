module RideShare

  class Driver < RideShare::User
    attr_reader :vin, :driven_trips, :status

    def initialize(input)
        super(input)

        if input[:vehicle_id].nil? || input[:vehicle_id] <= 0 || input[:vehicle_id] > 17
          raise ArgumentError, 'Invlid Vin'
        end

        @vehicle_id = input[:vehicle_id]
        @driven_trips = input[:driven_trips]
        @status = input[:status] ||= :AVAILABLE
        raise ArgumentError.new("Invalid Status") unless @status == :AVAILABLE || @status == :UNAVAILABLE

    end

  end

end
