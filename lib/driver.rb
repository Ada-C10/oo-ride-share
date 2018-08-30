
module RideShare
  class Driver < RideShare::User
    attr_reader :vehicle_id, :driven_trips, :status

    VALID_STATUS = [:AVAILABLE, :UNAVAILABLE]
    # ID, NAME, and PHONE NUMBER
    # id: 54, name: "Rogers Bartell IV",
      # vin: "1C9EVBRM0YBC564DZ",
      # phone: '111-111-1111',
      # status: :AVAILABLE
    # this is from user=> :id, :name, :phone_number, :trips
    def initialize (input)
      super(input)
      @vehicle_id = input[:vin]
      @driven_trips = trips
      @status = input[:status]
      raise ArgumentError if not VALID_STATUS.include?(status)
    end
  end
end
