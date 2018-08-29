require 'csv'
require "pry"

module RideShare
  class Trip
    attr_reader :id, :driver, :passenger, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time < @start_time
        raise ArgumentError, "End time #{@end_time} is before start time #{@start_time}!"
      end
    end

    def duration
      # returns duration in seconds
      return @end_time.to_i - @start_time.to_i
    end

    def inspect
      return "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

  end
end
