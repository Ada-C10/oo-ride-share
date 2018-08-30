require 'pry'

module RideShare
  class User
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      @id = input[:id] #user_ID/PassengerID
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips].nil? ? [] : input[:trips]
    end

    def add_trip(trip)
      @trips << trip
    end


    # return total amount of money user spent on trips
    def net_expenditures
      ride_total = 0
      @trips.each do |trip|
        ride_total += trip[:cost]
      end
      return ride_total
    end

  #   RideShare::Trip.duration - don't need RideShare? NO, same module
  #
  #   return total amout of time user has spent on the trips
  #   def total_time_spent
  #     total_time = 0
  #     @trips.each do |trip|
  #       total_time += trip
  #     end
  #     return total_time
  #   end
  # end
end
