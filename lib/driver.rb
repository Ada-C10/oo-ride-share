module RideShare
  class Driver < User
    attr_reader :vin
    attr_accessor :driven_trips, :status

    def initialize(input)
      super(input)
      if input[:vin].length != 17
        raise ArgumentError, 'ID must be 17 characters'
      end

      # valid_staus = [:AVAILABLE, :UNAVAILABLE]
      # if valid_staus.include?(@status)
      #   raise ArgumentError, 'Not a valid status'
      # end

      @vin = input[:vin]
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]
      @status = input[:status] == nil ? :AVAILABLE : input[:status]
    end

    def average_rating
      total_ratings = 0
      @driven_trips.each do |trip|
        total_ratings += trip.rating
      end

      if @driven_trips.length == 0
        average = 0
      else
        average = (total_ratings.to_f) / @driven_trips.length
      end

      return average
    end


    # def average_rating
    #   ratings = @driven_trips.find { |trip| trip.rating } #FIX ME PLEASE
    #   # binding.pry
    #   average = ratings.sum / @driven_trips.length
    #   total_ratings = 0
    #   @trips.each do |trip|
    #     total_ratings += trip.rating
    #   end
    #
    #   if trips.length == 0
    #     average = 0
    #   else
    #     average = (total_ratings.to_f) / trips.length
    #   end
    #   return average
    # end

    def add_driven_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to driven_trips array")
      end
      @driven_trips << trip
      return @driven_trips
    end

    def total_revenue
      revenue = 0.0
      income = 0.0
      @driven_trips.each do |trip|
        if trip.cost == nil
          raise ArgumentError, "Trip still in progress, no revenue"
        else
          revenue = (trip.cost - 1.65) * 0.8
          income += revenue
        end
      end
      return income.round(2)
    end

    def net_expenditures
      return super - total_revenue
    end

  end
end
