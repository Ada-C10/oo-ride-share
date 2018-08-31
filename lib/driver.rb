#require 'pry'

module RideShare
  class Driver < User
    attr_reader :vehicle_id, :driven_trips
    attr_accessor :status

    def initialize(data)
      super(data)
      # @id = data[:id]
      @vehicle_id = data[:vin]
      @driven_trips = data[:driven_trips].nil? ? [] : data[:driven_trips]
      @status = data[:status]

    # def initialize(id, name, phone_number, trips, vehicle_id, driven_trips, status)
    #   super(id, name, phone_number, trips)
    #     @vehicle_id = vehicle_id
    #     @driven_trips =  drivers[:driven_trips].nil? ? [] : drivers[:driven_trips]
    #     @status = status


# use find passenger and merge with user to make one hash and pass into constructor?


      good_status = [:AVAILABLE, :UNAVAILABLE]

      unless good_status.include? @status
        raise ArgumentError.new("That status is not recognized")
      end
    end # end of def initialize

    def add_driven_trip(trip)
      # @trips.each do |trip|
      #   if Trip.id
      #
      @driven_trips << trip
    end

  end # end of Class User
end # end of Module
