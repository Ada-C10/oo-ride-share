require_relative 'spec_helper'
require 'pry'

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
      # expect(dispatcher.drivers).must_be_kind_of Array
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

  describe "load_trips method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                                 DRIVER_TEST_FILE)
    end

    it "Tests for time conversion from string to time instances" do
      5.times do |i|
        expect(@dispatcher.trips[i].start_time).must_be_instance_of Time
        expect(@dispatcher.trips[i].end_time).must_be_instance_of Time
      end
    end



  end




  # Uncomment for Wave 2
  describe "find_driver method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                                 DRIVER_TEST_FILE)
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
        expect(driver).must_be_instance_of RideShare::Driver
        expect(driver.driven_trips).must_include trip
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

      expect(passenger).must_be_instance_of RideShare::User
      expect(passenger.trips).must_include trip
    end
  end

  describe "request_trip method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                  TRIP_TEST_FILE,
                                                  DRIVER_TEST_FILE)
    end

    it 'adds a new trip to the collection by 1' do
      num_trips_before = @dispatcher.trips.length
      @dispatcher.request_trip(4)
      num_trips_after = @dispatcher.trips.length

      expect(num_trips_after).must_equal num_trips_before + 1
    end

    it 'adds a new instance of Trip' do
      @dispatcher.request_trip(5)

      expect(@dispatcher.trips.last).must_be_instance_of RideShare::Trip
    end

    it 'returns a new instance of Trip' do
      expect(@dispatcher.request_trip(5)).must_be_instance_of RideShare::Trip
    end

    it 'makes the previously available driver unavailable' do
      old_status = @dispatcher.find_driver(5).status #5 is the first available driver

      expect(old_status).must_equal :AVAILABLE

      trip = @dispatcher.request_trip(3)

      expect(trip.driver.id).must_equal 5

      new_status = @dispatcher.find_driver(5).status

      expect(new_status).must_equal :UNAVAILABLE
    end

    it 'does not allow the passenger to also be the driver' do
      trip = @dispatcher.request_trip(5)  #5 is the first available driver

      expect(trip.driver).wont_equal 5
    end

    it 'adds a new trip to passenger trips array' do
      passenger = @dispatcher.find_passenger(2)
      num_trips_before = passenger.trips.length
      @dispatcher.request_trip(2)
      num_trips_after = passenger.trips.length

      expect(num_trips_after).must_equal num_trips_before + 1
    end

    it 'adds a new trip to driver trips array' do
      driver = @dispatcher.find_driver(5) #5 is the first available driver
      num_trips_before = driver.driven_trips.length
      @dispatcher.request_trip(2)
      num_trips_after = driver.driven_trips.length

      expect(num_trips_after).must_equal num_trips_before + 1
    end



  end

end
