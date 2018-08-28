require_relative "trip"
require_relative "user"
require "Time"
require "ap"
require "pry"

module RideShare
  class Driver < User
    attr_reader :id, :name, :status
    binding.pry

    def initialize(input)
      super()



      # # @vehicle_id = input[:vehicle_id]
      # @driven_trips = []
      @status = input[:status]


      puts "ID #{@id} and #{id}"
      puts "NAME #{@name} and #{name}"
      puts "STATUS #{@status} and #{status}"
      # unless input[:vehicle_id] == 17
      #   raise ArgumentError, 'Vehicle ID must contain 17 characters'
      # end
      #
      # unless input[:status] == :AVAILBLE || input[:status] == :UNAVAILABLE
      #   raise ArgumentError, 'Vehicle ID must contain 17 characters'
      # end

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


driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", status: :AVAILABLE)

puts driver.id
puts driver.name
puts driver.status
