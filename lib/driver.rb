require_relative 'user'


module RideShare
  class Driver < User

  attr_reader :vehicle_id, :status, :driven_trips

    def initialize(input)
      super(input)
      @vehicle_id = input[:vehicle_id]
      @status = input[:status]
      @driven_trips = input[:trips].nil? ? [] : input[:trips]
      unless input[:vehicle_id].length == 17 || input[:vehicle_id] != ""
        raise ArgumentError
      end
    end

    #assinged as to_i in dispatch spec but binding is a float in driver.rb
    def add_driven_trip(trip)
      raise ArgumentError unless trip.class == Trip


      @driven_trips << trip #using the method in load trips to call
    end

    def average_rating
      if @driven_trips == []
        return 0
      else
        sum = 0

        driven_trips.each do |trip|
          sum += trip.rating
        end
        return sum.to_f / @driven_trips.length
      end
    end
  end
end
