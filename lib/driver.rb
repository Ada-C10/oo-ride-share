require 'pry'
module RideShare
  class Driver < RideShare::User
    attr_reader :vehicle_id, :driven_trips, :status
    FEE = 1.65.freeze
    DRIVER_PERCENTAGE = 0.8.freeze

    VALID_STATUS = [:AVAILABLE, :UNAVAILABLE]
    # ID, NAME, and PHONE NUMBER
    # id: 54, name: "Rogers Bartell IV",
      # vin: "1C9EVBRM0YBC564DZ",
      # phone: '111-111-1111',
      # status: :AVAILABLE
    # this is from user=> :id, :name, :phone_number, :trips
    def initialize (input)
      super(input)
      @id = input[:id]
      @vehicle_id = input[:vin]
      raise ArgumentError if @vehicle_id.length != 17
      @status = input[:status]
      #input[:trips] = [] if input[:trips] == nil
      #@driven_trips = input[:trips]
      @driven_trips ||= []
      #raise ArgumentError if not VALID_STATUS.include?(status)
    end

    def average_rating
      ratings = @driven_trips.map do |trip|
        rate = trip.rating
      end
      rating_sum = ratings.sum
      average_rating = rating_sum.to_f/driven_trips.length.to_f
      return 0 if @driven_trips.length == 0

      return average_rating
    end

    def total_revenue
      total = 0
      return total if @driven_trips.length == 0

      @driven_trips.each do |trip|
        total += trip.cost
      end
      #[12, 32, 43]
      cost_sum = total * DRIVER_PERCENTAGE
      total_revenue = cost_sum - FEE
      return total_revenue
    end



    def add_driven_trip(trip)
      raise ArgumentError.new("Invalid Driver") unless trip.instance_of? RideShare::Trip
      @driven_trips << trip
    end
  end
end
