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

      valid_ratings = [*1..5, nil]
      unless valid_ratings.include? (rating)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    
      if end_time != nil
        if @end_time < @start_time
          raise ArgumentError.new
        end
      end
    end

    def calculate_duration
      duration = @end_time - @start_time
      return duration
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end
  end
end
