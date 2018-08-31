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

    it "handles case user not found" do
      passenger = @dispatcher.find_passenger(100)
      ###### WHAT'S HERE???
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
      driver = @dispatcher.find_driver(2)
      ###### WHAT'S HERE???
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

    it "Connects drivers with trips" do
      trips = @dispatcher.trips

      [trips.first, trips.last].each do |trip|
        driver = trip.driver
        expect(driver).must_be_instance_of Integer
        expect(@dispatcher.find_driver(driver).trips).must_include trip
      end
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
      expect(@dispatcher.find_passenger(passenger)).must_include trip
    end
  end



  describe "New in-progress trip: Request Trip(user_id)" do
    let (:dispatcher) {RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                     TRIP_TEST_FILE,
                                                     DRIVER_TEST_FILE)}
    # let (:driver) {RideShare::Driver.new()}

    it "creates trip properly" do
      dispatcher.request_trip(7)
      expect(dispatcher.trips.last).must_be_instance_of RideShare::Trip
    end

    it "updates trip list for passenger" do
      old_number_of_trips = (dispatcher.find_passenger(5).trips).length
      new_trip = dispatcher.request_trip(5)
      expect((dispatcher.find_passenger(5).trips).length).must_equal (old_number_of_trips + 1)
    end

    it "updates trip list for driver" do
    end

    it "selects first available driver" do
    end

    it "correctly handles NO AVILABLE DRIVERS situation" do
      #not required
      #excpetion with a resucue block
    end

    it "never has driver and passenger with same id" do
    end

    # it "sets driver's status to :UNAVAILABLE" do
    #   dispatcher.request_trip(5)
    #   expect()
    # end

    it "Wave 1&2 code ignores all in-progress trips (end time = nil)" do
    end
    # user_id, x
    # auto assign driver (first driver status available) x
    # PASSENGER????????
    # start time = Time.now
    # end TIME = nil (IN PROG)
    # cost = nil
    # rating = nil

    # helper method in Driver:
    # add new_in_progress_trip to driver.driven_trips [] (.add_driven_trip)
    # set driver.status = :unavailable

    # helper method in User:
    # add new trip to user.trips [] (.add_trip)

    # add new trip to trip_dispatcher's @trips
    # return new_in_progress_trip

    # wave 1&2 code:
    # ignores in-progress trips (if end time) is nil not included
    # write explicit tests for this situation

  end
end
