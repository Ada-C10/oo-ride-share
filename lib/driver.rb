module RideShare

  class Driver < User

    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      super(input)

      @vehicle_id = input[:vin]
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]
      @status = input[:status].nil? ? :AVAILABLE : input[:status]

      unless @vehicle_id.length == 17
        raise ArgumentError, "Invalid vehicle ID #{@vehicle_id}"
      end

      unless [:AVAILABLE, :UNAVAILABLE].include?(@status)
        raise ArgumentError, "Invalid status #{@status}"
      end

    end

    def average_rating
      if @driven_trips.length == 0
        return 0
      else
        return @driven_trips.sum { |trip| trip.rating } / @driven_trips.length
      end
    end

    def add_driven_trip(trip)
      unless trip.class == Trip
        raise ArgumentError, "Trip not provided"
      end

      @driven_trips << trip
    end

    def total_revenue
       return @driven_trips.sum { |trip| trip.cost - 1.65} * 0.80
    end

    def net_expenditures
      return total_revenue - super
    end



  end

end
