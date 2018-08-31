module RideShare
  class User
    attr_reader :id, :name, :phone_number, :trips

    # initialize
    def initialize(input)
      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips].nil? ? [] : input[:trips]
    end

    # a method to add_trip to the User
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

    # a method for calculate the user's net_expenditure
    def net_expenditures
      return trips.sum {|trip| trip.cost}
    end

    # a method to calculate the total time spend for each user
    def total_time_spent
      return trips.sum {|trip| trip.duration}
    end
  end
end
