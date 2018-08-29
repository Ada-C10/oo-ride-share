
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
    end

    def total_time_spent
      total_time = 0
      @trips.each do |trip|
        total_time += trip.calculate_trip_duration
      end
      return total_time
    end
  end

  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status, :trips

  def initialize(id: 0, name: "no name", vin: 0, phone: 0, status: :UNAVAILABLE, trips: [])
    raise ArgumentError.new "Invalid VIN" if vin.length != 17
    raise ArgumentError.new "Invalid ID" if id <= 0
      @id = id
      @name = name
      @vehicle_id = vin
      @phone = phone
      @status = status
      @driven_trips = []
      @trips = trips
    end
  end
end
