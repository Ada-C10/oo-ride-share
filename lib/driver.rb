require_relative 'user'

class Driver < User

  def initialize(input)
    super(input) #do we need this? purpose is to inherit id
    @vehicle_id = vehicle_id
    @status = status
    @driven_trips = [] #not sure if we should inherit from use
  end
end
