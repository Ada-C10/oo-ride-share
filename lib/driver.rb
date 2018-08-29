module RideShare

  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status


    def initialize(input)
      super(input)
      #user has access to id, name, phone_number
      #so does driver

      @vehicle_id = input[:vin]
      @status = input[:status]
      # @driven_trips = input[:trips].nil? ? [] : input[:trips]
      raise ArgumentError.new() unless [:UNAVAILABLE, :AVAILABLE].include? input[:status]
    end


  end
end
