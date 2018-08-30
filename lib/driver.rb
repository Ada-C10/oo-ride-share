require_relative 'trip'
require_relative 'user'
require 'Time'

module RideShare
  # class Driver < User
  #   attr_reader :vehicle_id, :driven_trips, :status, :trips, :id, :name

  # def initialize(id: 0, name: "", vehicle_id: "", phone: "", status: :UNAVAILABLE, trips:[], driven_trips: [])
  # raise ArgumentError.new "Invalid VIN" if vin.length != 17
  # raise ArgumentError.new "Invalid ID" if id <= 0
  # @id = id
  # @name = name
  # @vin = vin
  # @phone_number = phone
  # @status = status
  # @driven_trips = driven_trips
  # @trips = trips
  class Driver < User
    attr_reader :vin, :driven_trips, :status

    def initialize(input)
      super (input)


       if input[:vin].length == 17
        @vin = input[:vin]
       else
         raise ArgumentError.new('Invalid VIN ')
       end

       @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

       if [:AVAILABLE, :UNAVAILABLE].include? (input[:status])
        @status = input[:status]
       else
         raise ArgumentError.new('Invalid STATUS')
       end

    end

  end

  def add_driven_trip(trips)
    @driven_trips << trips
  end
end
