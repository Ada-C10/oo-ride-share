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
      # print "#{trips}"
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
        total_time += trip.calculate_duration_in_sec
      end

      return total_time
    end
  end
end
