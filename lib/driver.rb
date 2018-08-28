#driver class
module RideShare
  class Driver < User
    attr_reader :vehicle_id, :status, :driven_trips

    def initialize(input)
      super(input)

      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      @vehicle_id = input[:vin].to_s
      # binding.pry
      if @vehicle_id.length != 17 || @vehicle_id.empty?
        raise ArgumentError, 'Invalid VIN'
      end
      @status = (input[:status]).to_sym
    end
end

gitend