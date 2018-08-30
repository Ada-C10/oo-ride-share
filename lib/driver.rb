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

      # TODO : we added statuses to all drivers in the spect file -- how can we avoid doing that if not passed as a parameter but still reach the argument error?

      @vehicle_id = input[:vin]
      @driven_trips = input[:trips].nil? ? [] : input[:trips]
      @status = input[:status] ? input[:status] : :AVAILABLE


      unless @vehicle_id.length == 17
        raise ArgumentError, 'Vehicle ID must contain 17 characters'
      end

      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError, 'Not a valid status.'
      end

      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      # @id = input[:id]
      # @name = input[:name]
      # @phone_number = input[:phone]

    end

    # def add_trip(trip)
    #
    # end

    def average_rating()

      if @driven_trips.empty?
        return 0
      else
        rating_sum = @driven_trips.sum { |driven_trip| driven_trip.rating }
        trips_driven = @driven_trips.length

        return rating_sum / trips_driven.to_f
      end
    end

    def add_driven_trip(trip)

      unless trip.class == RideShare::Trip
        raise ArgumentError, 'This is not a valid trip'
      end

      @driven_trips << trip

    end


    def total_revenue()
      if @driven_trips.empty?
        return 0
      else
        total_sum = @driven_trips.sum { |driven_trip| (driven_trip.cost - 1.65) }

        return total_sum * 0.80
      end
    end

    # TODO: making tests for total revenue (that's where we left off!)

    def net_expenditures()

    end

  end
end


# pass = RideShare::User.new(id: 1, name: "Ada", phone: "412-432-7640")
#
# driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
#
# trip = RideShare::Trip.new({id: 8, passenger: pass, start_time: Time.parse("2016-08-08T12:14:00+00:00"), end_time: Time.parse("2018-05-20T12:14:00+00:00"),  cost: 55, rating: 5, driver: driver})
# #
#
# ap driver.status
# ap driver.id
# ap driver.name
# driver.add_trip(trip)
# driver.add_driven_trip
# ap driver.driven_trips
