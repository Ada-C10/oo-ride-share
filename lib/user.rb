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

    def add_trip(trip)
      @trips << trip
    end


    def net_expenditures
      trip_cost_sum = 0
      @trips.each do |trip|
        if trip.cost == "In Progress"
          next
        else
         trip_cost_sum += trip.cost
        end
      end
      return trip_cost_sum
    end

    def total_time_spent
      total_time_as_a_passenger = 0
      @trips.each do |trip|
        if trip.duration == "In Progress"
          next
        else
          total_time_as_a_passenger += trip.duration
        end
      end
      return total_time_as_a_passenger
    end
  end
end
