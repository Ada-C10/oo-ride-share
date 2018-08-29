module RideShare

  class Driver < User
    attr_reader :vehicle_id
    attr_accessor :driven_trips, :status


    def initialize(input)
      super(input)

      @vehicle_id = input[:vin]
      @status = input[:status]


      raise ArgumentError.new() unless [:UNAVAILABLE, :AVAILABLE].include?(@status)

      raise ArgumentError.new() unless @vehicle_id.length == 17

    end



  end
end
