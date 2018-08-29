require_relative "user"
require 'csv'
require 'time'

module RideShare
  class Driver < User
    attr_reader :vin
    attr_accessor :status, :driven_trips  #:trips is the trips taken as a user

    def initialize(input) #rather than input, pass in symbol vin, status, and driven trips
      super (input :id], input[:name], input[:phone_number], input[:trips])


      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      if input[:vin].length != 17
        raise ArgumentError, 'vin numbers must be 17 characters in length'
      end

      # rather than input[:vin], just :vin
      @vin = input[:vin]
      @status = input[:status]
      @driven_trips = input[:driven_trips]

    end


  end
end
