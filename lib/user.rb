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
    # Add an instance method, net_expenditures, to User that will return
    # the total amount of money that user has spent on their trips
    def net_expenditures

      total = 0
      @trips.each do |trip_inst|
        total += trip_inst.cost
      end
      # binding.pry
      return total
    end

    # Add an instance method, total_time_spent to User that will return
    # the total amount of time that user has spent on their trips
    def total_time_spent
      total_time = 0
      @trips.each do |trip_inst|
        total_time += (trip_inst.end_time - trip_inst.start_time)
      end
      # TODO: implement Time.parser to convert seconds to minutes
      # t = 236 # seconds
      # Time.at(t).utc.strftime("%H:%M:%S")
      # => "00:03:56"
      return total_time

    end
  end
end
