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
      cost_array = []
      @trips.each do |trip|
        cost_array << trip.cost
      end
      net = cost_array.sum
      return net
    end

    def total_time_spent
      duration_array = []

      @trips.each do |trip|
        duration_array << trip.duration #the duration is currently in seconds 
      end
      # binding.pry
      total_time_spent = duration_array.sum / 60 #60 represents seconds
      return total_time_spent
    end
  end
end
