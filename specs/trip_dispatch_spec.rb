require_relative 'spec_helper'
require "awesome_print"
USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'

describe "TripDispatcher class" do
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                                 DRIVER_TEST_FILE)
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = RideShare::TripDispatcher.new
      [:trips, :passengers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      expect(dispatcher.drivers).must_be_kind_of Array
    end
  end

  describe "find_user method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "finds a user instance" do
      passenger = @dispatcher.find_passenger(2)
      expect(passenger).must_be_kind_of RideShare::User
    end

# FAIL!
    it "handles case passenger (user) not found" do
      expect{@dispatcher.find_passenger(999)}.must_raise ArgumentError
    end

  end

  describe "find_driver method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(3)
      expect(driver).must_be_kind_of RideShare::Driver
    end

    it "handles case driver not found" do
      expect{@dispatcher.find_driver(999)}.must_raise ArgumentError
    end
  end

  describe "Driver & Trip loader methods" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                                 DRIVER_TEST_FILE)
    end

    it "accurately loads driver information into drivers array" do
      first_driver = @dispatcher.drivers.first
      last_driver = @dispatcher.drivers.last

      expect(first_driver.name).must_equal "Driver2"
      expect(first_driver.id).must_equal 2
      expect(first_driver.status).must_equal :UNAVAILABLE
      expect(last_driver.name).must_equal "Driver8"
      expect(last_driver.id).must_equal 8
      expect(last_driver.status).must_equal :AVAILABLE
    end
  end

  describe "User & Trip loader methods" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                  TRIP_TEST_FILE,
                                                  DRIVER_TEST_FILE)
    end

    it "accurately loads passenger information into passengers array" do
      first_passenger = @dispatcher.passengers.first
      last_passenger = @dispatcher.passengers.last

      expect(first_passenger.name).must_equal "User1"
      expect(first_passenger.id).must_equal 1
      expect(last_passenger.name).must_equal "Driver8"
      expect(last_passenger.id).must_equal 8
    end

    it "accurately loads trip info and associates trips with passengers" do
      trip = @dispatcher.trips.first
      passenger = trip.passenger

      expect(passenger).must_be_instance_of Integer
      expect(@dispatcher.find_passenger(passenger).trips).must_include trip
    end
  end



  describe "New in-progress trip: Request Trip(user_id)" do
    let (:dispatcher) {RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                     TRIP_TEST_FILE,
                                                     DRIVER_TEST_FILE)}

    it "creates trip properly" do
      dispatcher.request_trip(7)
      expect(dispatcher.trips.last).must_be_instance_of RideShare::Trip
    end

    it "Selects first available driver, and then updates trip list for passenger" do
      old_number_of_trips = (dispatcher.find_passenger(5).trips).length
      new_trip = dispatcher.request_trip(5)
      expect((dispatcher.find_passenger(5).trips).length).must_equal (old_number_of_trips + 1)
    end

    it "updates trip list for driver" do
      old_number_of_driven_trips = ((dispatcher.find_driver(5)).driven_trips).length
      new_trip = dispatcher.request_trip(1) # We expect this to assign the ride eto Driver 5
      expect(new_trip.driver).must_equal 5 # and it does! yay.
      expect((dispatcher.find_driver(5).driven_trips).length).must_equal (old_number_of_driven_trips + 1)
    end


    it "correctly handles NO AVILABLE DRIVERS situation" do
      2.times {new_trip = dispatcher.request_trip(1)}
      expect {dispatcher.available_driver(1)}.must_raise ArgumentError
    end

    it "never has driver and passenger with same id" do
      new_trip = dispatcher.request_trip(5)
      expect(new_trip.driver).must_equal 8
    end

    it "sets driver's status to :UNAVAILABLE" do
      new_trip = dispatcher.request_trip(1)
      expect((dispatcher.find_driver(5)).status).must_equal :UNAVAILABLE
    end

    it "Wave 1&2 code ignores all in-progress trips (end time = nil)" do
      new_trip = dispatcher.request_trip(1) # first available driver is 5
      user = dispatcher.find_passenger(1)
      driver = dispatcher.find_driver(5)
      #### User net expenditure
      expect(user.net_expenditures).must_equal 10 #passes!

      ### User total_time_spent
      expect(user.total_time_spent).must_equal ((32*60)+20)

      expect(driver.total_revenue).must_equal 40.04

      # driver net expenditures
      expect(driver.net_expenditures).must_equal -40.04
    end

  end
end
