require 'csv'
require 'time'
require 'pry'
# require_relative 'trip_dispatcher.rb'

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

      if @rating != nil && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time != nil && (@start_time > @end_time)
        raise ArgumentError.new("Start time greater than end time.")
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    #Add an instance method to the Trip class to calculate the duration of the trip in seconds, and a corresponding test
    def duration_of_trip
      begin
        duration = @end_time - @start_time
      rescue NoMethodError
        duration = nil
        puts "Cannot calculate duration of trip: still in progress."
      end
      return duration
    end
  end
end
