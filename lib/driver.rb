#require 'pry'

module RideShare
  class Driver < User
    attr_reader :vehicle_id, :driven_trips
    attr_accessor :status

    def initialize(data)
      # super(id, name, phone_number, trips)
      @vehicle_id = data[:vin]
      @driven_trips = data[:driven_trips]
      @status = data[:status]
    #  binding.pry
    end

  end
end
