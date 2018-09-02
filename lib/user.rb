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
      self.trips.each do |trip|
        total += trip.cost
      end
      return total
    end

def total_time_spent
  @passenger.trips.each do |trip|
    t1 = Time.parse(trip.start_time)
    t2 = Time.parse(trip.end_time)
    duration += sprintf("%0.02f", (t2 - t1) % 60)
      end
      return duration
    end 



  end
end
