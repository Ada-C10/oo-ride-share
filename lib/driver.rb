require_relative 'user'

module RideShare
  class Driver < User
    attr_reader :id, :name, :vin, :phone_number, :status, :driven_trips, :trips

    def initialize(input)
      super
      @vin = input[:vin]
      @driven_trips = input[:driven_trips]
      @status = input[:status]

      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      elsif input[:vin].length != 17
        raise ArgumentError, 'vin must be 17 characters'
      elsif input[:driven_trips].nil?
        @driven_trips = []
      end
    end

    def add_trip(trip)
      super
    end

    def add_driven_trip(trip)
      if trip.class == Trip
        @driven_trips << trip
      else
        raise ArgumentError, 'No Trip provided'
      end
    end

    def average_rating
      if driven_trips.length == 0
        return 0
      end

      rating = 0.0
      nil_count = 0
      @driven_trips.each do |trip|
        if trip.rating != nil
          rating += trip.rating
        else
          nil_count += 1
        end
      end

      rating = (rating/(@driven_trips.length - nil_count)).round(2)
      return rating
    end

    def total_revenue
      total_revenue = 0.0
      nil_count = 0
      @driven_trips.each do |trip|
        if trip.cost != nil
          total_revenue += trip.cost
        else
          nil_count += 1
        end
      end
      return ((total_revenue - (1.65 * (@driven_trips.length - nil_count))) * 0.8)
    end

    def net_expenditures
      net_income = super - self.total_revenue
      return net_income
    end

    def accept_trip(trip)
      @driven_trips << trip
      @status = :UNAVAILABLE
    end

  end
end
