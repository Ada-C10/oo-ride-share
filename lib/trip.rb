require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      raise ArgumentError unless @start_time < @end_time


      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def calculate_duration_in_sec
      start_in_second = (@start_time.hour * 3600) + (@start_time.min * 60) + @start_time.sec
      end_in_second = (@end_time.hour * 3600) + (@end_time.min * 60) + @end_time.sec
      duration = end_in_second - start_in_second
      return duration
    end
  end
end
