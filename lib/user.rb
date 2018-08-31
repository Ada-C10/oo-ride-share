module RideShare
  class User
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, "ID cannot be blank or less than zero (got #{input[:id]})."
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
      sum = 0
      @trips.each do |trip|
        sum += trip.cost
      end
      return sum
    end

    def total_time_spent
      total_time = 0
      @trips.each do |trip|
        total_time += trip.duration
      end
      return total_time
    end

    # For Wave 3:

    def add_new_in_progress_trip
      # helper method in User:
      # add new trip to user.trips [] (.add_trip)
      # can this be the same as the other?
    end

  end
end
