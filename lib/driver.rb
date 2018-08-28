require_relative 'user'

class Driver < User

attr_reader :vehicle_id, :status, :driven_trips

  def initialize(input)
    super(input)
    @vehicle_id = input[:vehicle_id]
    @status = input[:status]
    @driven_trips = input[:trips].nil? ? [] : input[:trips]
end

def add_driven_trip(trip)
  @driven_trips << trip #using the method in load trips to call
end
