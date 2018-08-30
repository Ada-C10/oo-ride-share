require 'csv'
require 'pry'
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


      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      difference = @end_time - @start_time
      if difference < 0
        raise ArgumentError.new("Endtime must be after start-time")
      end
    end

    def driver #How to access driver's data
      data[:vehicle_id] = nil
      data[:driven_trips] = @passenger.trips
      data[:status]
      @driver = RideShare::Driver.new(data)
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def duration
      duration = @end_time - @start_time
      return duration
      # @trip_data[:duration] = @trip_data[:end_time] - @trip_data[:start_time]
    end

  end

end
