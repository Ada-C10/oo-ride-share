require_relative 'spec_helper'
require 'pry'

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'

describe "Driver class" do

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

    it "throws an argument error with a bad ID value" do
      expect{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      expect{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
      expect{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
    end

    it "throws an argument error if invalid status is provided" do
      expect{ RideShare::Driver.new(id: 100, name: "George", status: :bloop)}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@driver.driven_trips).must_be_kind_of Array
      expect(@driver.driven_trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
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
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = Time.parse("2015-05-20T12:14:00+00:00")
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time , rating: 5})
    end

    it "throws an argument error if trip is not provided" do
      #binding.pry
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
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = Time.parse("2015-05-20T12:14:00+00:00")
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                      vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                 start_time: start_time, end_time: end_time, rating: 5)
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

    it "ignores in progress trips in calculating average rating" do
        @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                   TRIP_TEST_FILE,
                                                    DRIVER_TEST_FILE)
        start_time = Time.parse("2015-05-20T12:14:00+00:00")
        end_time = Time.parse("2015-05-20T12:14:00+00:00")
        user1 = @dispatcher.find_passenger(1)
        test_driver = @dispatcher.find_driver(2)
        test_trip = RideShare::Trip.new(id: 2, driver: test_driver, passenger: user1,
                                    start_time: start_time, end_time: nil, rating: nil, cost: nil)

        expect(test_driver.average_rating).must_equal 4.0

    end

    it "correctly calculates the average rating" do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = Time.parse("2015-05-20T12:14:00+00:00")
      trip2 = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                  start_time: start_time, end_time: end_time, rating: 1)

      @driver.add_driven_trip(trip2)

      expect(@driver.average_rating).must_be_close_to (5.0 + 1.0) / 2.0, 0.01
    end


  end

  describe "total_revenue" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                                  DRIVER_TEST_FILE)
    end

    it "calculates total_revenue for a driver" do
      test_driver = @dispatcher.drivers[0]
      money = ((10 - 1.65) * 0.8) + ((7 - 1.65) * 0.8)
      money = money.round(2)

      expect(test_driver.total_revenue).must_equal money
    end
  end

  describe "net_expenditures" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                                  DRIVER_TEST_FILE)
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = Time.parse("2015-05-20T12:14:00+00:00")
      test_trip = RideShare::Trip.new(id: 2, driver: @driver, passenger: nil,
                                  start_time: start_time, end_time: end_time, rating: 1, cost: 3)
      @dispatcher.trips << test_trip
      @driver = @dispatcher.find_driver(2)
      @driver.trips << test_trip
    end
    it "calculates driver's cost of trips taken minus total revenue" do
      revenue = 3 - (@driver.total_revenue)
      test_driver = @dispatcher.find_driver(2)

      expect(test_driver.net_expenditures).must_equal revenue

    end
  end
end
