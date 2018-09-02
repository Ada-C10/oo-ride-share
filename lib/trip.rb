require 'csv'
require 'pry'
require_relative 'user'
require 'time'

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

      if @rating == nil
        @rating = 0
      elsif @rating > 5 || @rating < 1
        # @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time == nil
        @end_time = "some end time"
      elsif @end_time < @start_time
        raise ArgumentError.new("Invalid Date: End date is before or on start date!")
      end

    end

    def inspect #what does this first line do?
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def duration #duration of the trip in second
      @duration = @end_time - @start_time

      return @duration.to_i
    end
  end
end
