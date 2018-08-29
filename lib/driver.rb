require_relative 'user'

module RideShare
  class Driver < User
    attr_reader :vin, :driven_trips, :status

    def initialize(input)
      super(input)

      @id = input[:id]
      # @name =
      # @phone_number =

      @vin = input[:vin]
      if @vin.length != 17
        raise ArgumentError.new("Invalid VIN")
      else
        @vin = input[:vin]
      end

      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      @status = input[:status]

      if @status != :AVAILABLE && @status != :UNAVAILABLE
        raise ArgumentError.new("Invalid status entered.")
      else
        @status = input[:status]
      end


    end

  end
end
