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
      # Returns the total amount of money that user has spent on their trips
    end

    def total_time_spent
      # Returns the total amount of time that user has spent on their trips
      total_time = 0
      @trips.each do |trip|
        total_time += trip.trip_duration
      end
      return total_time
    end

  end

  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(id: 0, name: "no name", vin: 0, phone: 0, status: :UNAVAILABLE)
      raise ArgumentError.new "ID not valid" if id <= 0
      raise ArgumentError.new "Invalid VIN" if vin.length != 17
      @id = id
      @name = name
      @vehicle_id = vin
      @phone = phone
      raise ArgumentError.new "Invalid status" if status != :AVAILABLE && status != :UNAVAILABLE
      @status = status
      @driven_trips = []
    end

    def average_rating
      #This method sums up the ratings from all a Driver's trips and returns the average
    end

    def add_driven_trip
      #This method adds a trip to the driver's collection of trips for which they have acted as a driver
    end

    def total_revenue
      #This method calculates that driver's total revenue across all their trips. Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted.
    end

    def net_expenditures
      #This method will override the cooresponding method in User and take the total amount a driver has spent as a passenger and subtract the amount they have earned as a driver (see above). If the number is negative the driver will earn money.
    end
  end


end
