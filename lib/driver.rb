require 'pry'
module RideShare
  class Driver < RideShare::User
    attr_reader :vehicle_id, :driven_trips, :status

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
      if average_rating == "NaN"
        return 0
      end

      return average_rating
    end



    def add_driven_trip(trip)
      raise ArgumentError.new("Invalid Driver") unless trip.instance_of? RideShare::Trip
      @driven_trips << trip
    end
  end
end
