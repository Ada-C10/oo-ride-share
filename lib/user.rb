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
    attr_reader :vehicle_id, :driven_trips, :status, :id, :name, :phone_number, :trips
    # attr_accessor :name, :trips


    def initialize(input)

      # super(id, name, phone_number, trips)

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips].nil? ? [] : input[:trips]
      # we don't need these because it already has it (it inherits from user)

      unless input[:vin].length == 17
        raise ArgumentError, "Vehicle ID is invalid."
      end
      @vehicle_id = input[:vin]  #check to make sure has 17
      valid_status = [:AVAILABLE, :UNAVAILABLE]
      unless valid_status.include? input[:status]
        raise ArgumentError, "Invalid driver status."
      end
      @status = input[:status] #check to make sure status is valid
      @driven_trips = []
    end
  end


end
