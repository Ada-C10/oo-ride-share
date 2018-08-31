require 'csv'

module RideShare
  class Trip
    attr_reader :id, :driver, :passenger, :start_time, :end_time, :cost, :rating

    def initialize(input)
      unless input[:end_time] == nil
        raise ArgumentError.new "Start time must be before end time!" if input[:start_time] >= input[:end_time]
      end
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      unless @rating == nil
        raise ArgumentError.new("Invalid rating #{@rating}") if @rating > 5 || @rating < 1
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def trip_duration
      return @end_time == nil ? nil : duration = @end_time - @start_time
    end

  end
end
