require 'csv'
require 'pry'
require_relative 'user'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :start_time, :end_time, :cost, :rating, :duration

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

        if @end_time < @start_time
          raise ArgumentError.new("Invalid Date: End date is before or on start date!")
        end

    end

    def inspect #what does this first line do?
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    # end_time = Time.parse('2014-05-21T12:14:00+40:00')
    # start_time = Time.parse('2014-05-21T12:14:00+00:00')
    # seconds = t.hour * 3600 + t.min * 60 + t.sec

    def duration #duration of the trip in second
      # @end_time = Time.parse(@end_time)
      # @start_time = Time.parse(@start_time)

      @duration = @end_time - @start_time
      # @duration = Time.parse(@duration)

      # @duration_in_hour = @end_time.hour - @start_time.hour
      # @duration_in_min = @end_time.min - @start_time.min
      # @duration_in_sec = @end_time.sec - @end_time.sec

      # @final_duration = @duration.hour * 3600 + @duration.min * 60 + @duration.sec
      # @duration = @duration_in_hour * 3600 + @duration_in_min * 60 + @duration_in_sec
      return @duration.to_i
    end
  end
end

##################
#
#
#  start_time = '2015-05-20T12:14:10+00:00'
# # puts "start"
# # puts start_time
# #
#  end_time = '2015-05-20T12:20:40+00:00'
# #
# # puts "Time: "
# # puts  start_time <=> end_time
# #
# trip_data = {
#   id: 8,
#   passenger: RideShare::User.new(id: 1,
#                                  name: "Ada",
#                                  phone: "412-432-7640"),
#   start_time: start_time,
#   end_time: end_time,
#   cost: 23.45,
#   rating: 3
# }
# #
# # trip = RideShare::Trip.new(@trip_data)
# # # puts trip
#
# puts trip =  RideShare::Trip.new(trip_data)
# puts trip.duration
