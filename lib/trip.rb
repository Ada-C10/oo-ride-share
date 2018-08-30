require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :start_time, :end_time, :cost, :rating, :driver

    def initialize(input)
      @id = input[:id]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]
      @driver = input[:driver]

      if @end_time != nil && (@start_time > @end_time)
        raise ArgumentError, "Start time can't be after end time"
      end
      if @rating != nil && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating: #{@rating}")
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def duration
      if end_time == nil
        raise RideShare::InProgressTripError.new("Trip is still in progress.")
      end
      return end_time - start_time
    end
  end

  class InProgressTripError < StandardError
  end
end
