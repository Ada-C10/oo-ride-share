require_relative 'user'
require 'pry'

module RideShare
  class Driver < User
<<<<<<< HEAD
    attr_reader :id, :name, :vin, :phone_number, :status
    #
    def initialize(input)
      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end
      @vin = input[:vin]
      @driven_trips = input[:driven_trips]
      @status = input[:status]
=======
    attr_reader :vin :driven_trips :status

    def initialize (id, name, phone_number, trips, vin, driven_trips, status)

      super (id, name, phone_number, trips)
      @vin = vin
      @driven_trips = driven_trips
      @status = status

>>>>>>> ee0ef0a4b0f83d613de3f9b2e70950ef41445285
    end

  end
end
