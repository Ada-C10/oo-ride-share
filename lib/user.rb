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
      if trip.class != Trip
        raise ArgumentError, "A Trip was not provided"
      end
      @trips.each do |item|
         if item == trip
           raise ArgumentError, "Duplicated trip"
         end
       end
      @trips << trip
    end

    def net_expenditures
      return trips.sum {|trip| trip.cost}
    end

    def total_time_spent
      return trips.sum {|trip| trip.duration}
    end
  end
end
