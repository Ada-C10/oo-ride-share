require_relative 'user'

class Driver < User
  def initialize(input)
    super(input)
    @vehicle_id = input[:vehicle_id]
    @driven_trips = input[:driven_trips]
    @status = input[:status]

  end

end
