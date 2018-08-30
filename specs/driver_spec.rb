require_relative 'spec_helper'

describe "Driver class" do
  before do
    @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
      vin: "1C9EVBRM0YBC564DZ",
      phone: '111-111-1111',
      status: :AVAILABLE)
  end

  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        phone: '111-111-1111',
        status: :AVAILABLE)
    end

    it "is an instance of Driver" do
      expect(@driver).must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad status" do
      expect{ RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        phone: '111-111-1111',
        status: :NOTVALID) }.must_raise ArgumentError
    end

    it "throws an argument error with a bad ID value" do
      expect{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      expect{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
      expect{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@driver.trips).must_be_kind_of Array
      expect(@driver.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      # Is this supposed to be vehicle_id or vin?
      [:id, :name, :vehicle_id, :status, :driven_trips].each do |prop|
        expect(@driver).must_respond_to prop
      end

      expect(@driver.id).must_be_kind_of Integer
      expect(@driver.name).must_be_kind_of String
      expect(@driver.vehicle_id).must_be_kind_of String
      expect(@driver.status).must_be_kind_of Symbol
    end
  end

  describe "add_driven_trip method" do
    before do
      pass = RideShare::User.new(id: 1, name: "Ada", phone: "412-432-7640")
      # TEST CODE HERE
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: "2016-08-08", end_time:"2016-08-09", rating: 5})
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        phone: '111-111-1111',
        status: :AVAILABLE)
    # @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, date: "2016-08-08", rating: 5})
    end

    it "throws an argument error if trip is not provided" do
      expect{ @driver.add_driven_trip(1) }.must_raise ArgumentError
    end

    it "increases the trip count by one" do
      previous = @driver.driven_trips.length
      @driver.add_driven_trip(@trip)
      expect(@driver.driven_trips.length).must_equal previous + 1
    end
  end

  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        phone: '111-111-1111',
        status: :AVAILABLE)
      # trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
      #                           date: Time.parse("2016-08-08"), rating: 5)
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: "2016-08-08", end_time:"2016-08-09", rating: 5})
      @driver.add_driven_trip(trip)
    end

    it "returns a float" do
      expect(@driver.average_rating).must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      expect(average).must_be :>=, 1.0
      expect(average).must_be :<=, 5.0
    end

    it "returns zero if no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                     vin: "1C9EVBRM0YBC564DZ")
      expect(driver.average_rating).must_equal 0
    end

    it "correctly calculates the average rating" do
      trip2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: "2016-08-08", end_time:"2016-08-09", rating: 1})
       @driver.add_driven_trip(trip2)

      expect(@driver.average_rating).must_be_close_to (5.0 + 1.0) / 2.0, 0.01
    end

    it "does not include in-progress trips when calculating the average rating" do
      trip1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: "2016-08-08", end_time:"2016-08-09", rating: 1})
       @driver.add_driven_trip(trip1)
      trip2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: "2016-08-08", end_time: nil, rating: nil})
        @driver.add_driven_trip(trip2)

        # Should only be 1 as there is one completed trip with a rating of 3
        expect(@driver.average_rating).must_equal 3
    end

  end

  describe "Driver#total_revenue" do
    # Setting up trip for test
    before do
      @driver_with_revenue = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        phone: '111-111-1111',
        status: :AVAILABLE)

      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }

      # Adding three trips for testing
      @trip = RideShare::Trip.new(@trip_data)
      @trip2 = RideShare::Trip.new(@trip_data)
      @trip3 = RideShare::Trip.new(@trip_data)
      @trip4 = RideShare::Trip.new({
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: nil,
        cost: nil,
        rating: nil
        })

      @driver_with_revenue.add_driven_trip(@trip)
      @driver_with_revenue.add_driven_trip(@trip2)
      @driver_with_revenue.add_driven_trip(@trip3)
    end

    it "Does not include in-progress trips" do
      # Should not include trip 4 as that trip is in progress
      # Adding invalid trip to driver
      @driver_with_revenue.add_driven_trip(@trip4)

      expect(@driver_with_revenue.total_revenue).must_equal (((23.45 - 1.65) * 3 ) * 0.80).round(2)
    end

  	it "returns a float" do
      expect(@driver_with_revenue.total_revenue).must_be_kind_of Float

  	end

  	it "calculates the the total amount a driver has earned to two digits" do
      # @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: "2016-08-08", end_time:"2016-08-09", rating: 5})

      # (trip - fee) * 0.80
      # All three trips are the same for this test
      expect(@driver_with_revenue.total_revenue).must_equal (((23.45 - 1.65) * 3 ) * 0.80).round(2)
  	end

  	it "returns 0 if a driver has not driven yet" do
      # Ceating driver with no trips
      @driver = RideShare::Driver.new(id: 82, name: "Cassy A",
        vin: "1C9EVBRM0YBC564DZ",
        phone: '111-111-1111',
        status: :AVAILABLE)
      expect(@driver.total_revenue).must_equal 0
  	end
  end

  describe "Driver#net_expenditures" do
    before do
      @driver_net_expenditures = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        phone: '111-111-1111',
        status: :AVAILABLE)

      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }

      # Adding three trips for testing
      @trip = RideShare::Trip.new(@trip_data)
      @trip2 = RideShare::Trip.new(@trip_data)
      @trip3 = RideShare::Trip.new(@trip_data)
      @trip4 = RideShare::Trip.new({
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: nil,
        cost: nil,
        rating: nil
        })

      @driver_net_expenditures.add_driven_trip(@trip)
      @driver_net_expenditures.add_driven_trip(@trip2)
      @driver_net_expenditures.add_driven_trip(@trip3)
    end

    it "does not include in-progress trips" do
      # Adding in-progress trip
      @driver_net_expenditures.add_driven_trip(@trip4)
      # Validating that in-progress trip is not included in calculation
      # add passenger trip where driver is a passenger
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @ride_data = {
        id: 8,
        passenger: RideShare::User.new(id: 54,
                                       name: "Rogers Bartell IV",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }

      @ride_trip = RideShare::Trip.new(@ride_data)

      # Add trip to trips
      @driver_net_expenditures.add_trip(@ride_trip)

      # Amount spent as passenger - Amount earned as a driver
      expect(@driver_net_expenditures.net_expenditures).must_equal(23.45 - @driver_net_expenditures.total_revenue)
    end

  	it "returns a float" do
      expect(@driver_net_expenditures.net_expenditures).must_be_kind_of Float
  	end

  	it "calculates the the amount a driver has earned net of their passenger expenses" do
      # add passenger trip where driver is a passenger
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @ride_data = {
        id: 8,
        passenger: RideShare::User.new(id: 54,
                                       name: "Rogers Bartell IV",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }

      @ride_trip = RideShare::Trip.new(@ride_data)

      # Add trip to trips
      @driver_net_expenditures.add_trip(@ride_trip)

      # Amount spent as passenger - Amount earned as a driver
      expect(@driver_net_expenditures.net_expenditures).must_equal(23.45 - @driver_net_expenditures.total_revenue)

  	end

  	# it "returns zero if passenger expenses and driver earnings are equal" do
    #
    #
  	# end
  end
end
