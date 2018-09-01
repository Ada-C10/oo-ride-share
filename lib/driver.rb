require_relative "trip"
require_relative "user"
require "time"
require "ap"
require "pry"

module RideShare
  class Driver < User
    attr_reader :id, :name, :vehicle_id, :driven_trips, :phone_number
    attr_accessor :status

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

      sum = 0

      if @driven_trips.empty?
        return 0
      else
        trips_amount = @driven_trips.length
        puts trips_amount
        puts @driven_trips

        @driven_trips.each do |trip|
          if !trip.rating.nil?
            sum += trip.rating
          end
        end
      end

        puts sum
        if sum != 0
          puts sum/trips_amount.to_f
          return sum / trips_amount.to_f
        end
    end

    def add_driven_trip(trip)

      unless trip.class == RideShare::Trip
        raise ArgumentError, 'This is not a valid trip'
      end

      @driven_trips << trip

    end


    def total_revenue()
      sum = 0
      if @driven_trips.empty?
        return 0
      else
        @driven_trips.each do |trip|
          if !trip.cost.nil?
            sum += (trip.cost - 1.65)
          end
        end
      end
        # total_sum = @driven_trips.sum { |driven_trip| (driven_trip.cost - 1.65) }

        if sum !=  0
          return ("%.2f" % (sum * 0.80)).to_f
        end
    end


    def net_expenditures()

      total_driver_revenue = total_revenue()

	    return ("%.2f" % (super - total_driver_revenue)).to_f
    end

    def change_status()
      if @status == :AVAILABLE
        return @status == :UNAVAILABLE
      end

    end

  end
end


# pass = RideShare::User.new(id: 1, name: "Ada", phone: "412-432-7640")
# #
# driver = RideShare::Driver.new(id: 1, name: "Ada", vin: "12345678912345678")
#
# trip_1 = RideShare::Trip.new({id: 8, passenger: "michael", start_time: Time.parse("2016-08-08T12:14:00+00:00"), end_time: Time.parse("2018-05-20T12:14:00+00:00"),  cost: 20, rating: 5, driver: driver})
#
# trip_2 = RideShare::Trip.new({id: 10, passenger: driver, start_time: Time.parse("2016-08-08T12:14:00+00:00"), end_time: Time.parse("2018-05-20T12:14:00+00:00"),  cost: 100, rating: 4, driver: "person"})
#
# driver.add_driven_trip(trip_1)
# driver.add_driven_trip(trip_2)
#
# ap driver.average_rating
#
# ap pass.trips
#
# ap driver.total_revenue
# ap driver.net_expenditures


# ap driver.status
# ap driver.id
# ap driver.name

# driver.add_driven_trip
# ap driver.driven_trips
