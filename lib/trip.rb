require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :start_time, :end_time, :cost, :rating, :driver

    def initialize(input)
      @id = input[:id]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost] ? input[:cost].to_f : nil
      @rating = input[:rating] ? input[:rating].to_i : nil
      @driver = input[:driver]
      unless @end_time == nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
      unless @end_time == nil
        if @start_time > @end_time
          raise ArgumentError, "Invalid input. Start time must be before end time."
        end
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def time_duration
      return @end_time - @start_time
    end
  end
end
