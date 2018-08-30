module RideShare

  class Driver < User
    attr_reader :vehicle_id
    attr_accessor :driven_trips, :status


    def initialize(input)
      super(input)

      @vehicle_id = input[:vin].to_s
      @status = input[:status]

      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      raise ArgumentError.new() unless [:UNAVAILABLE, :AVAILABLE].include?(@status)

      raise ArgumentError.new() unless @vehicle_id.length == 17

    end

    def add_driven_trip(trip)

      raise ArgumentError.new() if trip.class != Trip
      @driven_trips << trip
    end

    def average_rating
      if @driven_trips.length == 0
        return 0
      end

      rating = 0.0
      @driven_trips.each do |trip|
        rating += trip.rating
      end
      return rating / @driven_trips.length

    end
#This method calculates that driver's total revenue across all their trips. Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted.


def total_revenue
  total = 0.0
  @driven_trips.each do |trip|
    total += 0.8 * (trip.cost - 1.65)

  end
  return total


end






    # def add_driven_trip
#   @trips.each do |trip|
#     if user.id == trip[1]
#       @driven_trips << trip
#     end
#   end
# end

  end
end
