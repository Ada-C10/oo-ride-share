require 'pry'#driver class
module RideShare
  class Driver < User
    attr_reader :vehicle_id, :status, :driven_trips

    def initialize(input, status=:UNAVAILABLE)
      super(input)

      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      @vehicle_id = input[:vehicle_id].to_s      # binding.pry
        if @vehicle_id.length != 17 || @vehicle_id.empty?
          raise ArgumentError, 'Invalid VIN'
        end
      @status = (input[:status]).to_sym
        unless @status == :UNAVAILABLE || @status == :AVAILABLE
          raise ArgumentError, "invalid status"
        end
      @driven_trips = []
    end

    def average_rating
      completed_trips = @driven_trips.find_all { |trip| trip.end_time != nil }

      return 0 if completed_trips.empty?

      total = 0
      completed_trips.each do |trip|
        total += trip.rating
      end

      average = total.to_f / completed_trips.length
      return average
    end

    def add_driven_trip(trip)
      unless trip.instance_of? Trip
        raise ArgumentError, 'invalid trip data'
      end
      @driven_trips << trip
    end

    def add_trip_in_progress(trip)
      @status = :UNAVAILABLE
      @driven_trips << trip
    end

    def total_revenue
      completed_trips = @driven_trips.find_all { |trip| trip.end_time != nil }
      total = 0
      completed_trips.each do |trip|
        total += (trip.cost - 1.65) * 0.80
      end
      return total
    end

    def net_expenditures
      return (super - total_revenue)
    end

# latest drive developed for wave 4
    def latest_drive
      latest = @driven_trips.max {|trip| trip.end_time }.end_time
      return latest
    end

  end
end
