require_relative 'trip'
require_relative 'user'
require 'Time'
require 'pry'

module RideShare
  class Driver < User
    attr_reader :vin, :driven_trips
    attr_accessor :status

    def initialize(input)
      super (input) #id, name, phone_number, trips

      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      if input[:vin].length == 17
        @vin = input[:vin]
      else
        raise ArgumentError.new('That is not a valid VIN number')
      end

      if [:AVAILABLE, :UNAVAILABLE].include? (input[:status])
        @status = input[:status]
      else
        raise ArgumentError.new('That is not a valid status')
      end

    end

    def add_driven_trip(driver_trip)
      @driven_trips << driver_trip
    end

    def average_rating
      if driven_trips.length == 0
        return 0
      else
        sum_ratings =  driven_trips.reduce(0){|sum, trip| sum + trip.rating.to_f }
        return sum_ratings / driven_trips.length
      end
    end

    def total_revenue
      revenue = driven_trips.reduce(0){|sum, trip| sum + (trip.cost - 1.65) }
      revenue*= 0.8
      return revenue.round(2)
    end

    def net_expenditures
      #money_spent = super
      money_spent = trips.reduce(0){|sum, trip| sum + trip.cost }
      return money_spent - self.total_revenue
    end




  end
end

# driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
#                                 vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)
# trip = RideShare::Trip.new(id: 8, driver: driver, passenger: nil,
#                            start_time: Time.parse("2016-08-08"),
#                            end_time: Time.parse("2016-08-08"), rating: 5)
# driver.add_driven_trip(trip)
# binding.pry
# puts driver
