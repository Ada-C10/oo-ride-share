require_relative 'spec_helper'
require 'time'

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'
describe "TripDispatcher class" do
  before do
    @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                               TRIP_TEST_FILE,
                                                DRIVER_TEST_FILE)
  end

  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      expect(@dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      @dispatcher = RideShare::TripDispatcher.new
      [:trips, :passengers].each do |prop|
        expect(@dispatcher).must_respond_to prop
      end

      expect(@dispatcher.trips).must_be_kind_of Array
      expect(@dispatcher.passengers).must_be_kind_of Array
      expect(@dispatcher.drivers).must_be_kind_of Array
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
  end


  describe "find_driver method" do
    it "throws an argument error for a bad ID" do
      expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(2)
      expect(driver).must_be_kind_of RideShare::Driver
    end
  end

  describe "Driver & Trip loader methods" do
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
        expect(driver).must_be_instance_of RideShare::Driver
        # expect(driver.trips).must_include trip
      end
    end
  end

  describe "User & Trip loader methods" do
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

      expect(passenger).must_be_instance_of RideShare::User
      expect(passenger.trips).must_include trip
    end

    it "saves start and end time as Time objects" do
      trip = @dispatcher.trips.first
      trip_start_time = trip.start_time
      trip_end_time = trip.end_time

      expect(trip_start_time).must_be_instance_of Time
      expect(trip_end_time).must_be_instance_of Time
    end
  end

  describe "TripDispatcher#request_trip" do
    # this is the trip that should get created from the test data files
    #   @trip_data = {
    #     id: 6,
    #     passenger: @dispatcher.find_passenger(1),
    #     start_time: Time.now,
    #     end_time: nil,
    #     cost: nil,
    #     rating: nil,
    #     driver: @dispatcher.find_driver(5)
    #   }

    it "must call an available driver" do
      expect(@dispatcher.find_driver(5).status).must_equal :AVAILABLE
      expect(@dispatcher.request_trip(1).driver).must_equal @dispatcher.find_driver(5)
    end

    it "must return an instance of Trip" do
      expect(@dispatcher.request_trip(1)).must_be_instance_of RideShare::Trip
    end

    it "must return the correct trip information" do
      expect(@dispatcher.request_trip(1).id).must_equal 6
      expect(@dispatcher.request_trip(1).passenger).must_equal @dispatcher.find_passenger(1)
      # expect(@dispatcher.request_trip(1).start_time).must_equal Time.now
      expect(@dispatcher.request_trip(1).end_time).must_equal nil
      expect(@dispatcher.request_trip(1).cost).must_equal nil
      expect(@dispatcher.request_trip(1).rating).must_equal nil
      expect(@dispatcher.request_trip(1).driver).must_equal @dispatcher.find_driver(5)
    end

    it "must update the driver's driven trips and status" do
      # previously driver 5 had 3 trips
      expect(@dispatcher.find_driver(5).driven_trips.length).must_equal 4
      expect(@dispatcher.find_driver(5).status).must_equal :UNAVAILABLE
    end

    it "must update the user's trips" do
      # previously passenger 1 had 1 trip
      expect(@dispatcher.find_passenger(1).trips.length).must_equal 2
    end

    it "must assign a driver who is not the passenger" do
      # driver 5 is the passenger
      expect(@dispatcher.request_trip(5).driver).must_equal @dispatcher.find_driver(8)
    end

    it "must raise an ArgumentError" do # possibly custom error later on
      # set all drivers to unavailable
      @dispatcher.find_driver(5).status = :UNAVAILABLE
      @dispatcher.find_driver(8).status = :UNAVAILABLE

      expect{@dispatcher.request_trip(1)}.must_raise ArgumentError
    end

  end
end
