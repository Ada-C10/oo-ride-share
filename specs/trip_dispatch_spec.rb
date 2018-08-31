require_relative 'spec_helper'
require 'pry'

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'
TIME_ERROR_TEST_FILE = 'specs/test_data/trips_test_2.csv'

describe "TripDispatcher class" do
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = RideShare::TripDispatcher.new
      [:trips, :passengers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      # expect(dispatcher.drivers).must_be_kind_of Array
    end

  end

  describe "Load Trip method" do
    it "makes sure start_time and end_time is an instance of Time " do
      dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)

      dispatcher.trips.each do |trip|
        expect(trip.start_time).must_be_instance_of Time
        expect(trip.end_time).must_be_instance_of Time
      end
    end


    it "raises ArgumentError if end time is before start time" do

      expect{ RideShare::TripDispatcher.new(USER_TEST_FILE, TIME_ERROR_TEST_FILE, DRIVER_TEST_FILE) }.must_raise ArgumentError
    end

  end

  describe "find_user method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)
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
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)
    end

    it "throws an argument error for a bad ID" do
      expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do

      driver = @dispatcher.find_driver(2)

      expect(driver).must_be_kind_of RideShare::Driver
    end
  end

  describe "Driver & Trip loader methods" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)
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
        expect(driver).must_be_instance_of RideShare::Driver

        expect(driver.driven_trips).must_include trip
      end
    end
  end

  describe "User & Trip loader methods" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)
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

      expect(passenger).must_be_instance_of RideShare::User
      expect(passenger.trips).must_include trip
    end
  end

  describe "request_trip method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)
    end

    it "returns an instance of trip" do
      trip = @dispatcher.request_trip(1)

      expect (trip).must_be_instance_of RideShare::Trip
    end

    it "intializes the trip with cost, rating and end time set as nil" do
      trip = @dispatcher.request_trip(1)

      expect(trip.cost).must_be_instance_of NilClass
      expect(trip.rating).must_be_instance_of NilClass
      expect(trip.end_time).must_be_instance_of NilClass
    end

    it "passenger is user" do
      trip = @dispatcher.request_trip(1)
      expect(trip.passenger).must_be_instance_of RideShare::User
    end

    it "driver is instance of Driver" do
      trip = @dispatcher.request_trip(1)
      expect(trip.driver).must_be_instance_of RideShare::Driver
    end

    it "finds first driver with 'available' status" do
      trip = @dispatcher.request_trip(1)
      expect(trip.driver.id).must_equal 5
    end

    it "adds trip to @trips" do
      length = @dispatcher.trips.length
      @dispatcher.request_trip(1)
      expect(@dispatcher.trips.length).must_equal (length + 1)
    end

    it "the trip is added to a user's array of trips" do
      trip = @dispatcher.request_trip(1)
      user = @dispatcher.find_passenger(1)
      expect(user.trips.last).must_equal trip
    end

    it "add to driver's trips" do
      trip = @dispatcher.request_trip(1)
      expect(trip.driver.driven_trips.last).must_equal trip
    end

    it "it returns nil if there are no Available drivers " do
      @dispatcher.request_trip(1)
      @dispatcher.request_trip(3)

      expect (@dispatcher.request_trip(4)).must_be_nil
    end

    it "it raises an ArgumentError if a driver tries to drive themselves" do
      @dispatcher.request_trip(1)
      expect {@dispatcher.request_trip(8)}.must_raise ArgumentError
    end

  end

end
