require 'csv'
require 'time'
require 'pry'

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
        raise ArgumentError.new("Start time greater")
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    #Add an instance method to the Trip class to calculate the duration of the trip in seconds, and a corresponding test
    def duration_of_trip
      return @end_time - @start_time
    end
  end
end


# trip_data = {
#   id: 8,
#   passenger: "Div",
#   start_time: "2018-06-07 04:18:47 -0700",
#   end_time: "2018-06-07 04:19:25 -0700",
#   cost: 23.45,
#   rating: 3
# }
# trip = RideShare::Trip.new(trip_data)
# trip.duration_of_trip
