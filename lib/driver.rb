require_relative 'user'

class Driver < User
  attr_reader :vehicle_id, :driven_trips, :status

  def initialize(id, name, vin, phone, status)
    super(id, name, phone_number, trips)
    @vehicle_id = vin
    @driven_trips = trips
    @status = status
  end


end
