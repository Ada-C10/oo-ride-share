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
        total += trip.cost unless trip.end_time == nil
      end
      return total
    end

    def total_time_spent
      total_time = 0
      @trips.each do |trip|
        total_time += trip.trip_duration unless trip.end_time == nil
      end
      return total_time
    end

  end

  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status, :trips

    def initialize(id: 0, name: "no name", vin: 0, phone: 0, status: :UNAVAILABLE, trips: [])
      raise ArgumentError.new "ID not valid" if id <= 0
      raise ArgumentError.new "Invalid VIN" if vin.length != 17
      raise ArgumentError.new "Invalid status" if status != :AVAILABLE && status != :UNAVAILABLE
      @id = id
      @name = name
      @vehicle_id = vin
      @phone = phone
      @status = status
      @driven_trips = []
      @trips = trips
    end

    def average_rating
      sum = 0
      in_progress = 0

      @driven_trips.each do |trip|
        trip.end_time == nil ? in_progress += 1 : sum += trip.rating
      end

      valid_trips = @driven_trips.length - in_progress

      return valid_trips == 0 ? 0 : sum.to_f/valid_trips
    end

    def add_driven_trip(trip)
      raise ArgumentError, "Invalid trip object" unless trip.instance_of?(Trip)
      @driven_trips << trip
    end

    def total_revenue
      sum = 0

      @driven_trips.each do |driven_trip|
        sum += (driven_trip.cost - 1.65) * 0.8 unless driven_trip.end_time == nil
      end

      return sum.round(2)
    end

    def net_expenditures
      return super - self.total_revenue
    end

    def make_unavailable
      @status = :UNAVAILABLE
    end
  end
end
