require 'csv'
require 'driver'
require 'pry'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @passenger = input[:passenger]
      @driver = input[:driver]
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
      duration = @end_time - @start_time
      return duration
    end

  end
end
