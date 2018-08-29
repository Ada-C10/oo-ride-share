require 'pry'

module RideShare
  class User
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips].nil? ? [] : input[:trips]
    end

    # this is used in the load trip method
    # it collects the instances of trips and it is saves in the instance of trips for each user ^ anove
    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      net_total = 0
      @trips.each do |trip|
      net_total += trip.cost
      end
      return net_total
    end


    def total_time_spent #total time spent on user's trip
      net_time = 0
      @trips.each do |trip|
        net_time += trip.duration
      end
      return net_time
    end

  end
end
