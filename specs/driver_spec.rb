require_relative 'spec_helper'

describe "Driver class" do
  before do
    @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
      vin: "1C9EVBRM0YBC564DZ",
      phone: '111-111-1111',
      status: :AVAILABLE)
    @pass = RideShare::User.new(id: 1, name: "Ada", phone: "412-432-7640")
    @trip = RideShare::Trip.new({id: 2, driver: @driver, passenger: @pass, start_time: "2016-08-08", end_time:"2016-08-09", cost: 23.45, rating: 5})
    @trip2 = RideShare::Trip.new({id: 3, driver: @driver, passenger: @pass, start_time: "2016-08-08", end_time:"2016-08-09", cost: 23.45, rating: 1})
    @driver.add_driven_trip(@trip)
    @driver.add_driven_trip(@trip2)

    @trip3 = RideShare::Trip.new({id: 4, driver: @driver, passenger: @pass, start_time: "2016-08-08", end_time:"2016-08-09", cost: 23.45, rating: 1})
    @inprogress_trip = RideShare::Trip.new({id: 5, driver: @driver, passenger: @pass, start_time: "2016-08-08", end_time: nil, cost: nil, rating: nil})
    @rider_trip = RideShare::Trip.new({id: 6, driver: 9, passenger: @driver, start_time: "2016-08-08", end_time:"2016-08-09", cost: 23.45, rating: 1})

    @no_trip_driver = RideShare::Driver.new(id: 20, name: "Driver with no trips", vin: "1C9EVBRM0YBC564DZ")
  end

  describe "Driver instantiation" do

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
      expect(@no_trip_driver.trips).must_be_kind_of Array
      expect(@no_trip_driver.trips.length).must_equal 0
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
    it "returns a float" do
      expect(@driver.average_rating).must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      expect(average).must_be :>=, 1.0
      expect(average).must_be :<=, 5.0
    end

    it "returns zero if no trips" do
      expect(@no_trip_driver.average_rating).must_equal 0
    end

    it "correctly calculates the average rating" do
      expect(@driver.average_rating).must_be_close_to (@trip.rating + @trip2.rating) / 2.0, 0.01
    end

    it "does not include in-progress trips when calculating the average rating" do
        # Should only be 3 as there is one incomplete trip
        @driver.add_driven_trip(@inprogress_trip)
        expect(@driver.average_rating).must_equal 3
    end

  end

  describe "Driver#total_revenue" do
    # Setting up trips for test
    before do
      @driver.add_driven_trip(@trip3)
    end

    it "Does not include in-progress trips" do
      # Adding inprogress trip to driver
      @driver.add_driven_trip(@inprogress_trip)
      expect(@driver.total_revenue).must_equal (((23.45 - 1.65) * 3 ) * 0.80).round(2)
    end

  	it "returns a float" do
      expect(@driver.total_revenue).must_be_kind_of Float
  	end

  	it "calculates the the total amount a driver has earned to two digits" do
      # trip revenue = (trip - fee) * 0.80
      # All three trips are the same for this test
      expect(@driver.total_revenue).must_equal (((23.45 - 1.65) * 3 ) * 0.80).round(2)
  	end

  	it "returns 0 if a driver has not driven yet" do
      expect(@no_trip_driver.total_revenue).must_equal 0
  	end
  end

  describe "Driver#net_expenditures" do
    before do
      @driver.add_driven_trip(@trip3)
      @driver.add_trip(@rider_trip)
    end

    it "does not include in-progress trips" do
      # Adding in-progress trip
      @driver.add_driven_trip(@inprogress_trip)
      expect(@driver.net_expenditures).must_equal(23.45 - @driver.total_revenue)
    end

  	it "returns a float" do
      expect(@driver.net_expenditures).must_be_kind_of Float
  	end

  	it "calculates the the amount a driver has earned net of their passenger expenses" do
      # Amount spent as passenger - Amount earned as a driver
      expect(@driver.net_expenditures).must_equal(23.45 - @driver.total_revenue)
  	end
  end
end
