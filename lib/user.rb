module RideShare
  class User
    attr_accessor :id, :name, :phone_number, :trips

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
      completed_riden = filter_completed_trips(trips)
      # Add all the trip costs together
      return completed_riden.reduce(0) { |sum, trip| sum + trip.cost }
    end

    def total_time_spent
      completed_riden = filter_completed_trips(trips)
      return completed_riden.reduce(0) {|sum, trip| sum + trip.duration}
    end

    # returns an array of only completed driven trips
    def filter_completed_trips(driven_or_riden_trips)
      return driven_or_riden_trips.select { |trip| trip.end_time != nil }
    end
  end
end
