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

    def total_time_spent
      time = 0
      @trips.each do |trip|
        if trip.end_time != nil
          time += trip.calculate_duration
        end
      end
    end

    def net_expenditures

      @trips.reduce(0) do |sum, trip|

        if trip.end_time != nil
          sum + trip.cost
        end
      end
    end
    
  end
end
