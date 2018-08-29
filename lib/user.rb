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

    # that will return the total amount of money that user has spent on their trips
    def net_expenditures
      cost_array = []


      @trips.each do |trip|
        cost_array << trip.cost
      end

      net = cost_array.sum
      # binding.pry
      return net

    end

  end
end
