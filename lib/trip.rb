require 'csv'
require 'time'
# All times may have fraction. Be aware of this fact when comparing times with each other – times that are apparently equal when displayed may be different when compared.
#Time.new(year, month, date)

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

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
      
      if @start_time > @end_time
        raise ArgumentError.new("Invalid endtime")
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def trip_to_seconds
      midnight = Time.local(2018,8,26,0,0,0)

      start_seconds = (@start_time - midnight).to_i
      end_seconds = (@end_time - midnight).to_i

      @duration = (end_seconds - start_seconds)
      return @duration
    end
  end
end
