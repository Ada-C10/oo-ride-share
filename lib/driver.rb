require 'pry'
module RideShare

  class Driver < RideShare::User
    attr_reader :vin, :driven_trips, :status

    def initialize(input)
        super(input)

        if input[:vin] == nil || input[:vin] == "" || input[:vin].length > 17
          raise ArgumentError.new('Invalid Vin')
        end
        @vehicle_id = input[:vin]
        @driven_trips = input[:driven_trips]
        @status = input[:status] ||= :AVAILABLE
        raise ArgumentError.new("Invalid Status") unless @status == :AVAILABLE || @status == :UNAVAILABLE
    end
  end
end
