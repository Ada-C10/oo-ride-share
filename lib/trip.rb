require 'csv'
require 'pry'

module RideShare
  class Trip
    attr_reader :id, :passenger, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id] #trip ID
      @passenger = input[:passenger] #passenger ID
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end


      unless @end_time > @start_time
        raise ArgumentError.new("end time can not be before the start time end time is: #{@end_time} start time is #{@start_time}")
      end

    end

    def duration
      # binding.pry
      trip_in_seconds = @end_time - @start_time
      return trip_in_seconds
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end
  end
end
