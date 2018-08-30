
module RideShare

  class Driver < User

    attr_reader :vin, :status, :driven_trips

    def initialize(input)

      if input[:id].nil? || input[:id] <= 0
        raise ArgumentError, 'ID cannot be blank or less than zero.'
      end

      if input[:vin] == nil || input[:vin].length != 17 || input[:vin] == " "
        # binding.pry
        raise ArgumentError, 'Vin inaccurate, must be 17 characters long.'
      end

      # if input[:driven_trips] == []

      @vin	= input[:vin]
      @status = input[:status]
      @driven_trips	= []




      status_array = [:AVAILABLE, :UNAVAILABLE ]




      # binding.pry
      # unless @status.include?(status_array)
      #   raise ArgumentError. "Invalid status, you entered: #{status}"
      # end


    end



  end



end
