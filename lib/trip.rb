require 'csv'

module RideShare
  class Trip

#To make use of the new Driver class we will need to update the Trip class to include a reference to the trip's driver.
#add a driver attribute that calls find_driver to return a driver instance
    attr_reader :id, :driver, :passenger, :start_time, :end_time, :cost, :rating

    def initialize(input)
      raise ArgumentError.new "Start time must be before end time!" if input[:start_time] >= input[:end_time]
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
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

    def trip_duration
      return duration = @end_time - @start_time
    end

  end
end
