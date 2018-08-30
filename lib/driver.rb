require 'pry'
module RideShare

  class Driver < RideShare::User
    attr_reader :vin, :driven_trips, :status

    def initialize(input)
        super(input)

        if input[:vin] == nil || input[:vin] == "" || input[:vin].length > 17
          raise ArgumentError.new('Invalid Vin')
        end
        @vin = input[:vin]
        @driven_trips = input[:driven_trips] ||= []
        @status = input[:status] ||= :AVAILABLE
        raise ArgumentError.new("Invalid Status") unless @status == :AVAILABLE || @status == :UNAVAILABLE
    end

    def add_driven_trip(trip)
      check_id(trip.id)
      @driven_trips << super(trip) 

    end

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end

  end
end
