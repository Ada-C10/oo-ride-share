require 'pry'
module RideShare

  class Driver < RideShare::User
    attr_reader :vin, :driven_trips, :status

    def initialize(input)
      super(input)

      if input[:vin] == nil || input[:vin] == "" || input[:vin].length > 17
        raise ArgumentError.new('Invalid Vin')
      end
      @vin = input[:vin]
      @driven_trips = input[:driven_trips] ||= []
      @status = input[:status] ||= :AVAILABLE
      raise ArgumentError.new("Invalid Status") unless @status == :AVAILABLE || @status == :UNAVAILABLE
    end

    def add_driven_trip(trip)

      raise ArgumentError.new("Invalid Driver") unless trip.instance_of? RideShare::Trip
      @driven_trips << trip

    end

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end

    def average_rating
      return 0 if driven_trips.empty?
      all_ratings = []
      driven_trips.each do |trip|
        all_ratings << trip.rating
      end
      return average = (all_ratings.sum / all_ratings.length).to_f.round(1)
    end

    def total_revenue
      return 0 if driven_trips.empty?

      revenue = []
      driven_trips.each do |trip|
        raise ArgumentError.new("Invalid, cost can't be negetive") if trip.cost < 0
        num = trip.cost - 1.65
        num = num - (num * 0.2)
        revenue << num
      end

      return revenue.sum
    end

    def net_expenditures

      return (super - total_revenue)
      # cost_array = []
      # @trips.each do |trip|
      #   cost_array << trip.cost
      # end
      # net = cost_array.sum
      # net -= self.total_revenue
    end


  end
end
