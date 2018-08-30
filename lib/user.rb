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

    def total_time_spent #theres a way to use reduce
      total_time = 0
      @trips.each do |trip|
        total_time += trip.duration
      end
      return total_time
    end
  end

  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status, :id, :name, :phone_number, :trips, :driven_trips
    # attr_accessor :name, :trips


    def initialize(input, status = :UNAVAILABLE)

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips].nil? ? [] : input[:trips]

      unless input[:vin].length == 17
        raise ArgumentError, "Vehicle ID is invalid."
      end
      @vehicle_id = input[:vin]  #check to make sure has 17

      @status = input[:status].nil? ? input[:status] = :UNAVAILABLE : input[:status]

      valid_status = [:AVAILABLE, :UNAVAILABLE]

      unless valid_status.include? input[:status]
        raise ArgumentError, "Invalid driver status."
      end

      #check to make sure status is valid

      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]
    end

    def add_driven_trip(trip)
      if trip.class != RideShare::Trip
        raise ArgumentError, "Invalid Trip"
      else
        @driven_trips << trip
      end
    end

    def average_rating
      if self.driven_trips.length < 1
        return average_rating = 0
      end
      sum_ratings = self.driven_trips.reduce(0){|memo, trip| memo + trip.rating}
      average_rating = (sum_ratings/self.driven_trips.length).to_f.round(2)
      return average_rating
    end

    def total_revenue
      sum_costs = self.driven_trips.reduce(0){|memo, trip| memo + trip.cost}

      total_revenue = (sum_costs - (self.driven_trips.length * 1.65)) * 0.80

      return total_revenue.to_f.round(2)

    end
#     total_revenue	This method calculates that driver's total revenue across all their trips. Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted.

# net_expenditures	This method will override the cooresponding method in User and take the total amount a driver has spent as a passenger and subtract the amount they have earned as a driver (see above). If the number is negative the driver will earn money.

  end



end
