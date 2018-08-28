require_relative 'user'
require 'pry'

module RideShare
  class Driver < User
    attr_reader :id, :name, :vin, :phone_number, :status
    #
    def initialize(input)
      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end
      @vin = input[:vin]
      @driven_trips = input[:driven_trips]
      @status = input[:status]
    end

  end
end
