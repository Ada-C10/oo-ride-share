require 'csv'
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

      if  @rating == nil
        @rating = input[:rating]
      elsif @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end


      if  @end_time == nil
        @end_time == nil
      elsif @end_time < @start_time
        raise ArgumentError.new("Invalid start time and end time")
      end
    end

    def calculate_trip_duration
      if @end_time == nil
        return nil
      else
        seconds = (@end_time.to_i) - (@start_time.to_i)
        return seconds
      end
    end
  end

  def inspect
    "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
    "ID=#{id.inspect} " +
    "PassengerID=#{passenger&.id.inspect}>"
  end


end
