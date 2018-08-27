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
      total = 0
      @trips.each do |trip|
        total += trip.cost
      end
      return total
      # Returns the total amount of money that user has spent on their trips
    end

    def total_time_spent
      # Returns the total amount of time that user has spent on their trips
      total_time = 0
      @trips.each do |trip|
        total_time += trip.trip_duration
      end
      return total_time
    end

  end
end
