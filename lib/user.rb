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

    def total_time_spent
      total_time = 0
      @trips.each do |trip|
        if trip.end_time != nil
          total_time += trip.duration
        end
      end
      return total_time
    end

    def net_expenditures
      completed_trips = @trips.select{|trip| trip.end_time != nil}
      total = completed_trips.reduce(0) { |sum, trip| sum + trip.cost}

    return total
    end
  end


  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :id, :name, :phone_number, :trips, :driven_trips

    attr_accessor :status


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
      #exclude costs that == nil
      if self.driven_trips.length < 1
        return average_rating = 0
      end
      sum_ratings = self.driven_trips.reduce(0){|memo, trip| memo + trip.rating}
      average_rating = (sum_ratings/self.driven_trips.length).to_f.round(2)
      return average_rating
    end

    def total_revenue
      #exclude costs that == nil
      completed_trips = self.driven_trips.select{|trip| trip.end_time != nil}

      sum_costs = completed_trips.reduce(0){|memo, trip| memo + trip.cost}

      total_revenue = (sum_costs - (completed_trips.length * 1.65)) * 0.80

      return total_revenue.to_f.round(2)

    end

    def net_expenditures
      #exclude costs that == nil
      completed_trips_as_passenger = self.trips.select{|trip| trip.end_time != nil}

      spent_as_passenger = completed_trips_as_passenger.reduce(0){|memo, trip| memo + trip.cost}

      net_expenditures = spent_as_passenger.to_f.round(2) - self.total_revenue

      return net_expenditures
    end

  end

end
