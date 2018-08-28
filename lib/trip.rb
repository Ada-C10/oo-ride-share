require 'csv'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]
      @driver =

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
        if @end_time < @start_time
          raise ArgumentError.new("Invalid start time and end time")
        end
      end
        def inspect
          "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
          "ID=#{id.inspect} " +
          "PassengerID=#{passenger&.id.inspect}>"
        end
        def find_driver
          #retrieve the associated driver
        end
        def calculate_trip_duration
          seconds = (@end_time.to_i) - (@start_time.to_i)
          return seconds
      end
    end
  end
