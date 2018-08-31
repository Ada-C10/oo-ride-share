require 'csv'
require 'pry'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :start_time, :end_time, :cost, :rating, :driver_id, :driver

    def initialize(input)
      @id = input[:id]
      @passenger = input[:passenger]
      # 1. find which passanger is a driver by using ID (ID will be the same, drivers are super users which hahve extra id like driver id, and passager id in their trips)
            # the driver ID is the same as the user ID - use this find the passangers who are drivers
            # 1. find driver ID in trip.csv
            # 2. look in user.csv not the trip csv file , to find the driver info
            # 3. find the passangers who's driver is is the same as the passanger id, contact information will be in the user class and this has to be added to the passangers instance,
            # summary the passanger who are drivers will have information about their car and contact information, and their instance will be save in here
      # 2. add the diver info (like vin, and status, to their instance and save it in passangers -> each passanger that has )
           # the trip id is not the same as driver id

      #@passenger will be updated after replacing
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]
      @driver_id = input[:driver_id]
      @driver = input[:driver]


      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      difference = @end_time - @start_time
      if difference < 0
        raise ArgumentError.new("Endtime must be after start-time")
      end
    end

    def driver
      return @driver
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
