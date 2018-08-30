
module RideShare

  class Driver < User

    attr_reader :vin, :status, :driven_trips

    def initialize(input)
      @vin	= input[:vin]
      @status = input[:status]
      @driven_trips	= driven_trips



      status_array = [:AVAILABLE, :UNAVAILABLE ]

      # binding.pry
      # unless @status.include?(status_array)
      #   raise ArgumentError. "Invalid status, you entered: #{status}"
      # end


    end



  end



end
