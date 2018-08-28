require_relative "trip"
require_relative "user"
require "time"
require "ap"
require "pry"

module RideShare
  class Driver < User
    attr_reader :id, :name, :status, :vehicle_id, :driven_trips, :phone_number

    def initialize(input)
      super(input)

      @vehicle_id = input[:vin]
      @driven_trips = []
      @status = input[:status]

      puts @vehicle_id

      unless @vehicle_id.length == 17
        raise ArgumentError, 'Vehicle ID must contain 17 characters'
      end

      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError, 'Not a valid status.'
      end

      # if input[:id].nil? || input[:id] <= 0
      #   raise ArgumentError, 'ID cannot be blank or less than zero.'
      # end
      #
      # @id = input[:id]
      # @name = input[:name]
      # @phone_number = input[:phone]
      # @trips = input[:trips].nil? ? [] : input[:trips]
    end
  end
end


driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
  vin: "1C9EVBRM0YBC564DZ",
  phone: '111-111-1111',
  status: :AVAILABLE)

puts driver.id
puts driver.name
puts driver.status
