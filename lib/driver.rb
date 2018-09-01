require_relative "user"


module RideShare
  class Driver < User
    attr_reader :id, :name, :vehicle_id, :driven_trips, :phone_number
    attr_accessor :status

    def initialize(input)
      super(input)

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
    end

    def average_rating()

      sum = 0

      if @driven_trips.empty?
        return 0
      else
        trips_amount = @driven_trips.length

        valid_trips = @driven_trips.reject { |trip| trip.rating.nil? }

        return valid_trips.sum {|trip| trip.rating} / trips_amount.to_f
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
        valid_trips = @driven_trips.reject { |trip| trip.cost.nil? }

        revenue_made = valid_trips.sum {|trip| (trip.cost - 1.65) } * 0.80

        return ("%.2f" % revenue_made).to_f
      end
    end


    def net_expenditures()

      total_driver_revenue = total_revenue()

      if !(super.nil? && total_driver_revenue.nil?)
	       return ("%.2f" % (super - total_driver_revenue)).to_f
      end
    end
  end
end
